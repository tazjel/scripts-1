# coding: utf-8
from sys import exit

fo = open("charadas.txt", 'r')
array = []
fo.seek(0)
for i in fo:
	array.append(i)
fo.close()

def dead(morreu):
	print morreu
	exit(0)

def parabens():
	print "Resposta correta!"

def question(num):
	print array[num]
	resp = raw_input("> ")
	return resp

def level1(nome):
	print "Ola %s. seja bem vindo ao teste de logica!." % nome
	print "Vamos a sua primeira pergunta:\n"
	lvl1 = question(1)
	print lvl1
	if lvl1 == "756":
		parabens()
		level2()
	else:
		dead("Errado! Tente novamente")

def level2():
	lvl2 = question(2)
	if lvl2 == "13":
		parabens()
		level3()
	else:
		dead("Perdeu Playboy!")
	
def level3():
	lvl3 = question(3)
	
	if lvl3 == "homer" or lvl13 == "Home":
		homer = []
		for i in open("home.txt", 'r'):
			homer.append(i)
		for x in homer:
			print x
		parabens()

nome = question(0)
level1(nome)

fb = 0 + 1
