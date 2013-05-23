# Appname: deployer
# Created by: Raphael Rabelo - rabelo@raphaelr.com.br
# May-2013
# Valor Economico - 2013
########################################################
import fileinput
import argparse
import os
import tarfile

def fnEnv(env):
	print "Environments: ", env
	for i in env:
		print "\tSetup %r ... Please wait!" % i

def fnExtract(txtFile):
	tmpList = fileinput.input([txtFile[0]])
	for line in tmpList:
		newLine = line.strip('\n')
		fileList.append(newLine)
	
	fileList = []
	localPath = '/var/www/valor/online'
	for eachFile in fileList:
		print eachFile
		tar = tarfile.open(eachFile)
		tar.extractall()
		tar.close
	
		
def fnBackup():
	print "\tMaking backup..."
	
def fnDump():
	print "\tMaking dump..."

parser = argparse.ArgumentParser(prog='deployer')
# Add required=1 on -e
parser.add_argument('-e', '--environment', nargs='+', action='store', help='Environment to apply the package files.')
parser.add_argument('-l', '--list', nargs='+', action='store', help='List of files do deploy' )
parser.add_argument('-b', '--backup', action='store_false', help='Make backup of files.')
parser.add_argument('-u', '--dump', action='store_false', help='Make database dumping.')
args = parser.parse_args()
print "\nARGUMENTS:\n\t%r\n" % args

env=args.environment

if args.backup == False:
	fnBackup()
if args.dump == False:
	fnDump()

fnExtract(args.list)

## Read file line by line
#ArqTxt = 'lista.txt'
#Lista = fileinput.input([ArqTxt])