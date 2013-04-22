#!/usr/bin/python

vlHora=input('Digite o valor das horas trabalhadas: ')
qtdeHoras=input('Digite a quantidade de horas trabalhasdas por mes: ')
salBruto= vlHora * qtdeHoras
ir= salBruto * 0.11
inss= salBruto * 0.08
sindc= salBruto * 0.05
salLiq= salBruto - ir - inss - sindc

print 'Salario bruto: %s' %salBruto
print 'Valor pago de IR: %s' %ir
print 'Valor pago de INSS: %s' %inss
print 'Valor pago de SINDICATO: %s' %sindc
print 'Salario liquido: %s' %salLiq
