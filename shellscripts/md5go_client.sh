#!/bin/bash
pkgfilt=$1
pkgmd5=$2
rm -rf /tmp/beta.md5
cd /var/www/beta/htdocs
for i in `cat $pkgfilt`; do 
	md5sum $i >> /tmp/beta.md5
done

diff --brief $pkgmd5 /tmp/beta.md5

