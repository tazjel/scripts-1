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
userid=`id -un`
userhost=`who i am | awk -F " " '{print $5}'`
verify=0
optind=1

# Environment Definitions
docroot="/var/www/valor"
httpduser="apache"
httpgrp="websrv"

show_usage() {
echo -e "Usage: \n \
\tvalordep [-a ambiente] [-bucdxhv] [-f nome_do_arquivo.tar]\n\n \
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
\t\t[-x] \tNao mostra informacoes de debug.\n
\t\t[-h] \tExibe esse texto de ajuda.\n
\t\t[-v] \tExibe a versao do programa.\n
\t\t[-f] \tDefine o arquivo a ser aplicado em formato .tar \n"
}

function_initial() {
if [ $userid != "root" ]; then
        echo "Deve ser executado com root!"
        exit 1
fi

if [ $# -lt 1 ] || [ `id -un` != "root" ]; then
        show_usage
fi
if [ -d $dirlog ]; then
        touch $dirlog/$applog
else
        echo -ne "\t + Creating log file... "
        mkdir -p $dirlog ; touch $dirlog/$applog
        echo -e "OK"
fi
if [ -d $dirbkp ]; then
       create="1" 
else
        echo -ne "\t + Creating backup directory... "
        mkdir -p $dirbkp
        echo -e "OK"
fi
}

function_log() {
echo "[$datelog] - $amb - $userhost - $userid - $full_path - backup:${servers[2]}:$bkpfls:$bkpset - dump:${servers[1]}:$bkpdmp" >> $dirlog/$applog
echo -ne "\t + Registred in file log $dirlog/$applog"
}

function_exec_routine() {
for ((i=3 ; i<${#servers[@]} ; i++)); do
        echo -ne "\t + Copying $pack to ${servers[$i]}..."
        scp -q $full_path root@${servers[$i]}:/tmp;
        echo -e "OK"
done

for ((i=3 ; i<${#servers[@]} ; i++)); do
        echo -ne "\t + Extracting $pack on ${servers[$i]}..."
        ssh root@${servers[$i]} "tar -xf /tmp/$pack -C $remote_path"; done
        echo -e "OK\n"
for ((i=3 ; i<${#servers[@]} ; i++)); do
    echo -ne "\t + Applying permissions ${servers[$i]}..."
    for j in `ssh root@${servers[$i]} "tar -tf /tmp/$pack"`;
    do
        ssh root@${servers[$i]} "chmod 660 $remote_path/$j ; chown $httpuser:$httpdgrp $remote_path/$j";
    done
    echo -e "OK"
done
log
}

function_exec_list() {
# DESENV
}

function_check_files() {
for ((i=3 ; i<${#servers[@]} ; i++))
do
        echo -ne "\t + Verifying files in ${servers[$i]}..."
        ssh root@${servers[$i]} "find $remote_path -mount -type f -exec md5sum {} \+" | grep -v settings.php > /tmp/${servers[$i]}.txt
        sort /tmp/${servers[$i]}.txt > /tmp/files-${servers[$i]}.txt
        echo -e "OK!"
done

for ((i=3 ; i<${#servers[@]} ; i++))
do
        for ((j=3 ; j<${#servers[@]} ; j++))
        do
                diff --brief /tmp/files-${servers[$i]}.txt /tmp/files-${servers[$j]}.txt
        done
done
}

function_ambiente() {
case $amb in
        teste)  servers=("Teste" "10.1.0.52" "online" "10.1.0.52")
                db_options="-pvalor123"
        ;;
		#valid)  servers=("validacao" "web-valid-mysql01" "online" "10.1.1.35")
        #        db_options="-pvalor123"
        #;;
        #valid_blog) servers=("validacao" "web-valid-mysql01" "blogs" "10.1.1.35") 
        #        db_options="-pvalor123"
        #;;
        #preprod)  servers=("preprod" "web-preprod-mysql01" "online" "web-preprod-site")
        #          db_options="-pvalor123"
        #;;
        #preprod_blog)  servers=("preprod" "web-preprod-mysql1" "blogs" "web-preprod-site")
        #          db_options="-pvalor123"
        #;;
        #prod) servers=("valor_beta_ok" "mysql-pressflow2" "online" "www10" "www11" "www12" "www13" "mysql1" "mysql2")
        #      db_options="--single-transaction -udump_user -pdumping -h127.0.0.1 -P63306 --protocol=tcp --quote-names"
        #;;
        #prod_blog) servers=("valor_beta_ok" "mysql-pressflow2" "blogsvip" "www10" "www11" "www12" "www13")
        #      db_options="--single-transaction -udump_user -pdumping -h127.0.0.1 -P63306 --protocol=tcp --quote-names"
        #;;
        *) show_usage
esac

if [ $amb == "valid" ] || [ $amb == "preprod" ] || [ $amb == "prod" ] && [ -e $full_path ]; then
        remote_path="$docroot/${servers[2]}"
elif  [ $amb == "valid_blog" ] || [ $amb == "preprod_blog" ] || [ $amb == "prod_blog" ] && [ -e $full_path ]; then
        remote_path="$docroot/${servers[2]}"
else
        echo $usage
        exit 1
fi
}

function_backup() {
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
if [ $? -eq 0 ]; then
    echo -e "OK!"
else
    echo "ERROR!"
    exit 1
fi
}

function_dumping() {
bkpdmp="$dirbkp/dump_$amb-$data.sql.gz"
echo -ne "\t + Backuping ${servers[0]} database..."
ssh root@${servers[1]} "mysqldump $db_options ${servers[0]} | gzip > $bkpdmp"
if [ $? -eq 0 ]; then
    echo -e "OK"
else
    echo "ERROR!"
    exit 1
fi
}

function_file(){
if [ -z $arq ]; then
	exit 1
else
   full_path=$arq
   pack=`basename $arq`
   dirpack=`dirname $arq`
   function_exec_routine
fi
}

function_lista() {
# DESENV
x=0
for patch in `cat $lista`; do
	list[$x]=$patch
	let x++
done
}

while getopts a:f:l:bucdxvh ARGS; do
	case $ARGS in
		a)	amb="${OPTARG}"		&&	function_ambiente	;;
		f)	arq="${OPTARG}" 	&&	function_file		;;
		l)	lista="${OPTARG}"	&&	function_lista		;;
		b)	function_backup		;;
		u)	function_dumping	;;
		c)	verify=1	;;
		d)	set -x		;;
		x)	set +x		;;
		v)	echo -e "\n$appname v.$version - $lastmod \nby $author\n"	;;
		h)	show_usage	;;
		*)	show_usage	;;
	esac
done

if [ $verify -eq 1 ]; then
	check_files
else
	exit 0
fi

function_initial