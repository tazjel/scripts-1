# coding: utf-8

states = {
	'Oregon': 'OR',
	'Florida': 'FL',
	'California': 'CA',
	'New York': 'NY',
	'Michigan': 'MI'
}

# creates a basic set of states and some cities in them
cities = {
	'CA': 'San Franciso',
	'MI': 'Detroit',
	'FL': 'Jacksonville'
}

# add some more cities
cities['NY'] = 'New York'
cities['OR'] = 'Portland'

# print out some cities
print '-' * 10
print "NY State has: ", cities['NY']
print "OR State has: ", cities['OR']

# print some states
print '-' * 10
print "Michigan's abbreviation is: ", states['Michigan']
print "Florida's abbreviation is: ", states['Florida']

# do it by using the state then cities dict
print '-' * 10
print "Michigan has: ", cities[states['Michigan']]
print "Florida has: ", cities[states['Florida']]

# print every state abbreviation
print '-' * 10
for state, abbrev in states.items():
	print "%s has the city %s" % (abbrev, state)
	
# now, do both ateh the same time
print '-' * 10
for state, abbrev, in states.items():
	print "%s state is abbreviated %s and has city %s" % (state, abbrev, cities[abbrev])
	
print '-' * 10
#safely get a abbreviation by state that might not be there
state = states.get('Texas', None)

if not state:
	print "Sorry, no Texas."

# get a city with a default values
city = cities.get('TX', 'Does Not Exist')
print "The city for state 'TX' is: %s" % city

