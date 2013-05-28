#!/bin/bash
# Application Config.
appname="ValorDeploy"
version="4.0"
author="Raphael Rabelo"
lastmod="23-04-2013"
data=`date +%F_%H%M`
datelog=`date "+%d/%b/%Y:%H:%M:%S"`
dirbkp="/home/backups"
dirlog="/var/log/valorapps"
applog="valordep.log"
userhost=`who i am | awk -F " " '{print $5}'`
verify=0
optind=1
success=0
error=1

# Environment Definitions
docroot="/var/www/valor"
httpduser="apache"
httpgrp="websrv"

function check_error() {
	if [[ "$?" -eq "$success" ]]; then echo -e "OK"; else echo "ERROR" ; exit $error; fi
}

function show_usage() {
	echo -e "Usage: \n \
	\t`basename $0` [-a ambiente] [-bucdhv] [-f nome_do_arquivo.tar]\n\n \
	\t\t[-a] \tDefine o ambiente a ser aplicado. \n \
	\t\t\t|__valid - Aplica o pacote no ambiente de Validacao \n \
	\t\t\t|__valid_blog - Aplica o pacote no ambiente BlogsValorPRO de Validacao \n \
	\t\t\t|__preprod - Aplica o pacote no ambiente de Pre-producao \n \
	\t\t\t|__preprod_blog - Aplica o pacote no ambiente BlogsValorPRO de Pre-producao \n \
	\t\t\t|__prod - Aplica o pacote no ambiente de Producao \n \
	\t\t\t|__prod_blog - Aplica o pacote no ambiente BlogsValorPRO de Producao \n\n \
	\t\t[-b] \tExecuta backup de arquivos. \n \
	\t\t[-u] \tExecuta backup do banco de dados usando mysqldump.\n \
	\t\t[-c] \tExecuta verificacao de arquivos.\n \
	\t\t[-d] \tMostra informacoes de debug.\n \
	\t\t[-h] \tExibe esse texto de ajuda.\n
	\t\t[-v] \tExibe a versao do programa.\n
	\t\t[-f] \tDefine o arquivo a ser aplicado em formato .tar \n"
}

function initial() {
: ${amb?"See `basename $0 -h` to help"} ${$arq?"See `basename $0 -h` to help"} 
# Test if is a root user
	if [[ `id -un` != "root" ]]; then echo "Deve ser executado com root!" ; exit $error; fi
# Create a dir and log file
	if [[ -d $dirlog ]]; then touch $dirlog/$applog; else mkdir -p $dirlog ; touch $dirlog/$applog; fi

pack=`basename $arq`
exec_routine
}

function ambiente() {
case $amb in
	teste) servers=("Teste" "10.1.0.52" "online" "10.1.0.52") ; db_options="-p" ;;
	*) show_usage
esac

if [[ $amb == "valid" || $amb == "preprod" || $amb == "prod" ]]; then
	remote_path="$docroot/${servers[2]}"
elif [[ $amb == "valid_blog" || $amb == "preprod_blog" || $amb == "prod_blog" ]]; then
	remote_path="$docroot/${servers[2]}"
else
	echo $usage
	exit $error
fi
}

function exec_routine() {
	for ((i=3 ; i<${#servers[@]} ; i++)); do
		echo -ne "\t + Copying $pack to ${servers[$i]}..."
		scp -q $arq root@${servers[$i]}:/tmp;
		echo -e "OK"
	done
	for ((i=3 ; i<${#servers[@]} ; i++)); do
		echo -ne "\t + Extracting $pack on ${servers[$i]}..."
		ssh root@${servers[$i]} "tar -xf /tmp/$pack -C $remote_path"; 
	done
	echo -e "OK"
	for ((i=3 ; i<${#servers[@]} ; i++)); do
		echo -ne "\t + Applying permissions ${servers[$i]}..."
		for j in `ssh root@${servers[$i]} "tar -tf /tmp/$pack"`; do
			ssh root@${servers[$i]} "chmod 660 $remote_path/$j ; chown $httpuser:$httpdgrp $remote_path/$j";
		done
	echo -e "OK"
	done

	[[ "$verify" -eq "1" ]] && check_files || log
}

function exec_list() {
# DESENV
}

function check_files() {
	for ((i=3 ; i<${#servers[@]} ; i++)); do
        echo -ne "\t + Verifying files in ${servers[$i]}..."
        ssh root@${servers[$i]} "find $remote_path -mount -type f -exec md5sum {} \+" | grep -v settings.php > /tmp/${servers[$i]}.txt
        sort /tmp/${servers[$i]}.txt > /tmp/files-${servers[$i]}.txt
        echo -e "OK!"
	done

	for ((i=3 ; i<${#servers[@]} ; i++)); do
        for ((j=3 ; j<${#servers[@]} ; j++)); do
                diff --brief /tmp/files-${servers[$i]}.txt /tmp/files-${servers[$j]}.txt
        done
	done
	
	log
}

function log() {
echo "[$datelog] - $amb - $userhost - $arq - backup:${servers[2]}:$bkpfls:$bkpset - dump:${servers[1]}:$bkpdmp" >> $dirlog/$applog
echo -ne "\t + Registred in file log $dirlog/$applog"
}

function backup() {
bkpfls="files_${servers[2]}-$data.tar.gz"
echo -ne "\t + Backuping ${servers[2]} files..."
if [ $amb == "valid" ] || [ $amb == "preprod" ] || [ $amb == "prod" ]; then
	ssh root@${servers[3]} "cd $docroot/${servers[2]} ; tar -czf $dirbkp/$bkpfls --exclude sites/default/files/*' --exclude 'sites/mobile.valor.com.br/files/*' --exclude 'settings.php' online";
    bkpset="settings_${servers[2]}-$data.tar.gz"
    
	for ((i=3 ; i<${#servers[@]} ; i++)); do
		ssh root@${servers[$i]} "cd $docroot/${servers[2]} ; tar -czf $dirbkp/$bkpset sites/default/settings.php"
    done
else
    ssh root@${servers[3]} "cd $docroot ; tar -czf $dirbkp/$bkpfls ${servers[2]}"
fi
check_error
}

function dumping() {
bkpdmp="$dirbkp/dump_$amb-$data.sql.gz"
echo -ne "\t + Backuping ${servers[0]} database..."
ssh root@${servers[1]} "mysqldump $db_options ${servers[0]} | gzip > $bkpdmp"
check_error
}

function lista() {
# DESENV
if test ! -e "$lista"; then
	echo "Arquivo nao existe."
	exit $error
else
	x=0
	for patch in `cat $lista`; do
		list[$x]=$patch
		let x++
	done
print list
}

while getopts a:f:l:bucdvh ARGS; do
	case $ARGS in
		a)	amb="${OPTARG}"		&&	ambiente	;;
		f)	arq="${OPTARG}" 	&&	files		;;
		l)	lista="${OPTARG}"	&&	lista		;;
		b)	backup		;;
		u)	dumping		;;
		c)	verify=1	;;
		d)	set -x		;;
		v)	echo -e "\n$appname v.$version - $lastmod \nby $author\n"	;;
		h)	show_usage	;;
		*)	show_usage	;;
	esac
done

initial