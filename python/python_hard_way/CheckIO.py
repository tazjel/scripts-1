#python3.3 is inside
def checkio(els):
	i = 0
	sum = 0 
	for i in range(0, 3):
		sum = sum + els[i]
		i += 1

	return sum

if checkio([1, 2, 3, 4, 5, 6]) == 6:
    print('Done!')