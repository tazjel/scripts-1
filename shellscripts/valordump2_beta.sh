#!/bin/bash
set -x
APPNAME="ValorDump - DESENV"
VERSION="2.0 - BETA"
AUTHOR="Raphael Rabelo"
LASTMOD="Continuo..."
DATE=`date +%F_%H%M`
DATELOG=`date "+%d/%b/%Y:%H:%M:%S"`
DIRLOG="/var/log/valorapps"
APPLOG="valordump2.log"
USERID=`id -un`
USERHOST=`who i am | awk -F " " '{print $5}'`
#RMOUNT=""
OPTIND=1
MYSQLADMIN="/usr/bin/mysqladmin"
SERVERS=("testing" "localhost")
DB_OPTIONS="-p"
FILES="/producao"
COUNT=0

if [ $USERID != "root" ]; then
        echo "Deve ser executado com root!"
        break
fi

if [ $# -lt 1 ] || [ `id -un` != "root" ]; then
        echo -e $USAGE
fi

if [ -d $DIRLOG ]; then
        touch $DIRLOG/$APPLOG
else
        echo -ne "\t + Creating log file... "
        mkdir -p $DIRLOG ; touch $DIRLOG/$APPLOG
        echo -e "OK"
fi

function LOG() {
echo "[$DATELOG] $USERHOST - $USERID - RESTORED: $BANCO ON $ARQUIVO" >> $DIRLOG/$APPLOG
echo -e "\t + Registred in file log $DIRLOG/$APPLOG"
}

function QUERY_EXEC() {
echo -ne "\t + Aplicando querys do ambiente..."
mysql $DB_OPTIONS $BANCO -e 'update users set pass = md5(123) where uid = 1';
mysql $DB_OPTIONS $BANCO -e "UPDATE variable SET value = 's:7:\"0.0.0.0\";' WHERE name = 'apachesolr_host'";
mysql $DB_OPTIONS $BANCO -e "UPDATE variable SET value = 's:4:\"0000\";' WHERE name = 'apachesolr_port'";
mysql $DB_OPTIONS $BANCO -e "UPDATE variable SET value = 's:17:\"http://\";' WHERE name = 'valor_indexacao_host'";
mysql $DB_OPTIONS $BANCO -e "UPDATE variable SET value = 's:0:\"\";' WHERE name = 'interface_unica_path_webservice'";
mysql $DB_OPTIONS $BANCO -e "UPDATE variable SET value = '0' where name = 'valor_publicidade_ativo'";

if [ $? -eq 0 ]; then
        echo -e "OK"
        LOG
else
        echo -e "ERRO"
        exit 1
fi
}

function SAIR() {
dialog --stdout --title "SAIR" --yesno "\nDeseja sair do programa?\n" 0 0 
if [ $? -eq 0 ]; then
	clear
	break
else
	echo;
fi

}
#function GAUGE() {(
#while :; do
#((count+=10))
#[ $count -eq 110  ] && break
#cat <<EOF
#XXX
#$count
#POR FAVOR AGUARDE...$count%
#XXX
#EOF
#sleep 1
#done
#) | dialog --title "$APPNAME" --gauge "Aguarde" 7 70 0
#}

function DIR_FILES() {
ls $FILES/*.tar > /tmp/files.txt
sed 's|$|\t-|g' /tmp/files.txt > /tmp/files.out
sed 's|/producao/||g' /tmp/files.out > /tmp/files.out2

ARQUIVO=$(dialog --stdout --title "$APPNAME" --menu "Escolha o arquivo desejado:" 0 0 0 `cat /tmp/files.out2`)

[ $? -ne 0 ] && SAIR

dialog --stdout         \
--title "$APPNAME"      \
--yesno "As informacoes estao corretas?\n\nArquivo:\n\n $ARQUIVO \n" \
0 0			\

if [ $? -eq 0 ]; then
        dialog --title "$APPNAME" --infobox "\nExecutando restauracao de arquivos.\n" 0 0
        sleep 2
        GAUGE
        dialog --title "$APPNAME" --infobox "\nFeito!\n" 0 0
else
        dialog --title "$APPNAME" --infobox "\nEncerrando...\n" 0 0
        sleep 1
fi
}

function DIR_DUMP() {

ls $FILES/*.dump > /tmp/files.txt
sed 's|$|\t-|g' /tmp/files.txt > /tmp/files.out
sed 's|/producao/||g' /tmp/files.out > /tmp/files.out2

ARQUIVO=$(dialog --stdout 		\
--title "$APPNAME" 			\
--menu "Escolha o arquivo desejado:" 	\
0 0 0 `cat /tmp/files.out2`		)

[ $? -ne 0 ] && SAIR

BANCO=$(dialog --stdout 		\
--title "$APPNAME"			\
--inputbox "Digite no nome da base"	\
0 0 ""					)

[ $? -ne 0 ] && SAIR

dialog --stdout		\
--title "$APPANAME"	\
--yesno "As informacoes estao corretas?\n\nArquivo: $ARQUIVO \n\nBanco: $BANCO\n\nATENCAO: Apos confirmacao o banco de dados $BANCO sera DELETADO PERMANENTEMENTE\nNAO SENDO POSSIVEL RESTAURAR O SEU CONTEUDO.\n\n" 0 0		

if [ $? -eq 0 ]; then
	dialog --title "$APPNAME" --infobox "\nLimpando banco de dados $BANCO\n" 0 0
	sleep 2
	$MYSQLADMIN $DB_OPTIONS --force drop $BANCO
	$MYSQLADMIN $DB_OPTIONS create $BANCO
	
	dialog --title "$APPNAME" --infobox "\nRestaurando banco de dados. Por favor aguarde...\n" 0 0
	sleep 2
#	pv $ARQUIVO | mysql $DB_OPTIONS $BANCO
	(pv -n $ARQUIVO | mysql $DB_OPTIONS $BANCO ) 2>&1 | dialog --gauge "Running dump, please wait..." 10 70 0
	QUERY_EXEC
else
	dialog --title "$APPNAME" --infobox "\nSaindo...\n" 0 0
	sleep 2
fi
}

while :; do
ESCOLHA=$(dialog --stdout 		\
--title "$APPNAME"	 		\
--menu "\nEscolha a opcao desejada:" 	\
0 0 0					\
1 'Restaurar DUMP'			\
2 'Restaurar HTDOCS - NOK'		\
0 'Sair'				)
clear

rm -rf /tmp/files.out /tmp/files.out2
[ $? -ne 0 ] && break

case "$ESCOLHA" in 
	1) DIR_DUMP ;;
	2) break ; DIR_FILES ;;
	*) clear ; break ;;
esac
done
