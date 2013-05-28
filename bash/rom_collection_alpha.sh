#!/bin/bash
set -x
appname="ROM Collection"
appversion="1.0 beta"
changelog="\n\n**** CHANGELOG ****\n
15-01-2013 - Initial version!
\n
"
origem="$1"
destino="$2"
=("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z")
siglas=("A" "C" "E" "F" "FN" "G" "GR" "HK" "I" "J" "K" "NL" "PD" "S" "SW" "U" "UK" "Unk")
paises=("Australia" "China" "Europa" "Franca" "Finlandia" "Alemanha" "Grecia" "HongKong" "Italia" "Japao" "Coreia" "Holanda" "Publico" "Espanha" "Suecia" "USA" "Inglaterra" "PaisDesconhecido")
x=0


while [ $x -lt 18 ]; do
	mkdir -p $destino/${paises[$x]}
	find $origem -type f -name "*\(${siglas[$x]}\)*\[\!\]*" -exec cp {} $destino/${paises[$x]} \;
	let "x=x+1"
done

#find $destino -type d -empty -exec rm -rf {} \;


#while [ $x -lt 18 ]; do
#for i in ${siglas[$x]}; do
#        for j in ${paises[$x]}; do
#                echo $i - $j
#        done
#done
#let "x=x+1"
#done


#	find $romorigem -type f -name "*\($i\) \[\!\]*" -exec cp {} $romdestino/$cod \;
#	find $romdestino -type d -empty -exec rm -r {} \;
#	find $romorigem -type f -name "*[Hh][Aa][cC][kK]*" -exec cp {} $romdestino/$cod \;
