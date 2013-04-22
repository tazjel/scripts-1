#!/bin/bash
#set -x
pacotes="$1"
data=`date +%d%m%y%H%M%S`
servers=""

echo -ne "\t + Removendo arquivos antigos..."
rm -rf /tmp/*.list /tmp/*.filtered /tmp/*.md5
echo -e "OK"

echo -ne "\t + Gerando lista de arquivos..."
mkdir /tmp/pkg_$data
for i in `cat $pacotes`; do 
	tar -xf $i -C /var/www/beta/htdocs/
	tar -tf $i >> /tmp/pkg_$data.list
done 

sort /tmp/pkg_$data.list | awk '!a[$0]++' > /tmp/pkg_$data.filtered
#sed -i 's|^|/var/www/beta/htdocs/|' /tmp/pkg_$data
echo -e "OK"

echo -ne "\t + Gerando MD5SUM dos arquivos do pacote..."
cd  /var/www/beta/htdocs
for i in `cat /tmp/pkg_$data.filtered`; do
	md5sum $i >> /tmp/pkg_$data.md5
done
echo -e "OK"

for i in $servers; do
	echo -ne "\t + Copiando lista de arquivos para o servidori $i..."
	scp -q /tmp/pkg_$data.md5 /tmp/pkg_$data.filtered root@$i:/tmp
	echo -e "OK"
done

for i in $servers; do
	echo -ne "\t + Comparando arquivos no servidor $i..."
	ssh root@$i "sh /root/scripts/md5go_client.sh /tmp/pkg_$data.filtered /tmp/pkg_$data.md5"
	echo -e "OK"
done

