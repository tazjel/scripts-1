#!/usr/bin/python
from __future__ import division
linha='--------------'

print 'Hello World!'
print linha

n=input('Digite um numero:')
print n
print 'O numero digitado foi: %s' %n

print linha

n1=input('Digite um numero: ')
n2=input('Digite outro numero: ')
result= n1 + n2
print 'O resultado eh: %s ' %result
print linha

n1=input('Digite o primeiro numero: ')
n2=input('Digite o segundo numero: ')
n3=input('Digite o terceiro numero: ')
n4=input('Digite o quarto numero: ')
soma=n1 + n2 + n3 + n4
res= soma / 4
print 'A media das 4 notas eh: %s' %res
print linha

metros=input('Digite os metros a serem convertidos para centimetro: ')
cm= metros * 100
print metros,'metros','eh igual a %s'%cm,'centimetros'
print linha

n1=input('Digite um numero maior que 5: ')
if n1 > 5:
	print 'Parabens, esse numero eh maior que 5'
elif n1 < 5:
	print 'Ooops... esse numero nao eh maior que 5'
else:
	print 'Voce digitou 5!'

