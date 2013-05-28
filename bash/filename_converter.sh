#!/bin/bash
#
# Raphael Rabelo - 21-05-2012
#

menu()
{
echo "Converter 0.1"
echo "--------------------------------"
echo ""
echo "1. Converter MAIUSCULA -> minuscula"
echo "2. Converter minuscula -> MAIUSCULA"
read upperlow

case $upperlow in

	1) folder ; up2low ;;

	2) folder ; low2up ;;
	
	*) echo "ERROR 17" ;;
esac
}

folder()
{
read -p "Qual a pasta dos arquivos ? " path
}

up2low()
{
for upper in `ls $path`; do
cd $path
lower=`ls $upper | tr '[:upper:]' '[:lower:]'`
echo $lower
mv $upper $lower
cd -
done
IFS=$OLDIFS
}

low2up()
{
for lower in `ls $path`; do
cd $path
upper=`ls $lower | tr '[:lower:]' '[:upper:]'`
echo $upper
mv $lower $upper
cd -
done
IFS=$OLDIFS
}

OLDIFS=$IFS
IFS="
"
menu
