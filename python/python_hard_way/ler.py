# -- coding: utf-8 --
from sys import argv
script, filename = argv

arq = open(filename)
print arq.read()
arq.close()