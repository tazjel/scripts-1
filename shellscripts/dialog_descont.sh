#!/bin/bash
appname="Valor Restore beta"
count=0
files="/home/prod_files"

prereq=`command -v whitelist`
if [ $prereq -ne 0 ]; then
	echo "Este software requer o pacote 'dialog' para rodar."
	break
fi

function SAIR() {
dialog --stdout --title "SAIR" --yesno "\nDeseja sair do programa?\n" 0 0 
if [ $? -eq 0 ]; then
	clear
	break
else
	echo "ok"
fi

}
function GAUGE() {(
while :; do
((count+=10))
[ $count -eq 110  ] && break
cat <<EOF
XXX
$count
POR FAVOR AGUARDE...$count%
XXX
EOF
sleep 1
done
) | dialog --title "$appname" --gauge "Aguarde" 7 70 0
}

function DIR_FILES() {
ls $files/*.tar > /tmp/files.txt
sed 's|$|\t-|g' /tmp/files.txt > /tmp/files.out
sed 's|/home/prod_files/||g' /tmp/files.out > /tmp/files.out2

arquivo=$(dialog --stdout --title "$appname" --menu "Escolha o arquivo desejado:" 0 0 0 `cat /tmp/files.out2`)

[ $? -ne 0 ] && SAIR

dialog --stdout         \
--title "$appname"      \
--yesno "As informacoes estao corretas?\n\nArquivo:\n\n $arquivo \n" \
0 0			\

if [ $? -eq 0 ]; then
        dialog --title "$appname" --infobox "\nExecutando restauracao de arquivos.\n" 0 0
        sleep 2
        GAUGE
        dialog --title "$appname" --infobox "\nFeito!\n" 0 0
else
        dialog --title "$appname" --infobox "\nEncerrando...\n" 0 0
        sleep 1
fi
}

function DIR_DUMP() {
ls $files/*.dump > /tmp/files.txt
sed 's|$|\t-|g' /tmp/files.txt > /tmp/files.out
sed 's|/home/prod_files/||g' /tmp/files.out > /tmp/files.out2

arquivo=$(dialog --stdout 		\
--title "$appname" 			\
--menu "Escolha o arquivo desejado:" 	\
0 0 0 `cat /tmp/files.out2`		)

[ $? -ne 0 ] && SAIR

banco=$(dialog --stdout 		\
--title "$appname"			\
--inputbox "Digite no nome da base"	\
0 0 ""					)

[ $? -ne 0 ] && SAIR

dialog --stdout		\
--title "$appname"	\
--yesno "As informacoes estao corretas?\n\nArquivo: $arquivo \n\nBanco: $banco" \
0 0		

if [ $? -eq 0 ]; then
	dialog --title "$appname" --infobox "\nExecutando restauracao de base.\n" 0 0
	sleep 2
	GAUGE
	dialog --title "$appname" --infobox "\nFeito!\n" 0 0
else
	dialog --title "$appname" --infobox "\nSaindo...\n" 0 0
	sleep 1
fi
}

while :; do
escolha=$(dialog --stdout 		\
--title "$appname"	 		\
--menu "\nEscolha a opcao desejada:" 	\
0 0 0					\
1 'Restaurar dump'			\
2 'Restaurar HTDOCS'			\
0 'Sair'				)
clear

rm -rf /tmp/files.out /tmp/files.out2
[ $? -ne 0 ] && break

case "$escolha" in 
	1) DIR_DUMP ;;
	2) DIR_FILES ;;
	*) clear ; break ;;
esac
done
