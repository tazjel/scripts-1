# coding: utf-8

class People(object):
	pass
	
class Person(People):
	def __init__(self, name, age):
		self.name = name
		self.age = age
		print name, age

person1 = Person("Rabelo", 26)