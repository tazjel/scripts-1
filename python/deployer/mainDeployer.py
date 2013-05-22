import fileinput
import argparse

def fnEnviron(environments):
	print "Environments: ", args.environment
	for i in environments:
		print "Setup %s ... Please wait!" % i
		
def fnBackup():
	print "\tMaking backup..."
	flagOK = '1'
	
def fnDump():
	print "\tMaking dump..."
	flagOK = '1'
	
parser = argparse.ArgumentParser(prog='valordep')
parser.add_argument('-e', '--environment', nargs='+', required=1, action='store', help='Environment to apply the package files.')
parser.add_argument('-b', '--backup', nargs='*', action='store', help='Make backup of files.')
parser.add_argument('-u', '--dump', nargs='*', action='store', help='Make database dumping.')
args = parser.parse_args()
print "ARGS: ", args


if args.backup != None and len(args.backup) == 0:
	fnBackup()
if args.dump != None and len(args.backup) == 0:
	fnDump()
	
## Read file line by line
#ArqTxt = 'lista.txt'
#Lista = fileinput.input([ArqTxt])
