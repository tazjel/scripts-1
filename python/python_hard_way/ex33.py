# coding: utf-8

x = 15
increment = 1

def numeros(x, inc):
	i = 1
	numbers = []
	while i < x:
		numbers.append(i)
		i += inc
		print "Numbers now: ", numbers

print "The numbers:"
numeros(x, increment)