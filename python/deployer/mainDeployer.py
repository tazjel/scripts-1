# Appname: Deployer
# Created by: Raphael Rabelo - raphael.rabelo[a]valor.com.br
# May-2013
# Valor Economico - 2013
########################################################
import fileinput
import argparse
import os
import tarfile
from sys import exit

localPath = '/tmp/_valor_online.tmp/'
remotePath = '/var/www/valor/online'

def fnEnv(env):
	print "Environments: ", env
	for i in env:
		print "\tSetup %r ... Please wait!" % i

def fnExtFile(arq):
	# Clean the tmp folder before extract files	
	os.system('rm -rf %s' % localPath)
	tar = tarfile.open(arq)
	tar.extractall(localPath)
	tar.close
	extractOk = True
	return extractOk
	
def fnExtList(txtFile):
	fileList = []
	tmpList = fileinput.input([txtFile[0]])
	# Feed the fileList array with the args passed from tmpList
	for line in tmpList:
		newLine = line.strip('\n')
		fileList.append(newLine)
	# Clean the tmp folder before extract files	
	os.system('rm -rf %s' % localPath)
	# Extract file on path defined in 'localPath'
	for eachFile in fileList:
		if tarfile.is_tarfile(eachFile):
			print "\t=> Extracting %r on %r" % (eachFile, localPath)
			tar = tarfile.open(eachFile)
			tar.extractall(localPath)
			tar.close
			extractOk = True
		else:
			print "ERROR: The file %r isn't a TAR file." % eachFile
			extractOk = False
			exit(1)
	return extractOk
	
		
def fnBackup():
	print "\tMaking backup..."
	
def fnDump():
	print "\tMaking dump..."

parser = argparse.ArgumentParser(prog='deployer')
parser.add_argument('-e', '--environment', nargs='+', required=1, action='store', help='Environment to apply the package files.')
parser.add_argument('-f', '--file', nargs=1, action='store', help='File to deploy - Must be a .tar file.')
parser.add_argument('-l', '--list', nargs='+', action='store', help='List of files do deploy.')
parser.add_argument('-b', '--backup', action='store_false', help='Make backup of files.')
parser.add_argument('-u', '--dump', action='store_false', help='Make database dumping.')
args = parser.parse_args()
print "\nARGUMENTS:\n\t%r\n" % args

env = args.environment

# Checks if options -b and/or -u was set and call the function
if args.backup == False:
	fnBackup()
if args.dump == False:
	fnDump()

if args.file != None:
	if tarfile.is_tarfile(args.file[0]):
		if fnExtFile(args.file[0]) == True:
			for i in env:
				os.system('fab web_%s' % i)
				exit(0)
	else:
		print "ERROR"
		exit(1)
else:
	pass

if args.list != None:
	if fnExtList(args.list) == True:
		for i in env:
			os.system('fab web_%s' % i)
	else:
		exit(1)
else:
	pass

## Read file line by line
#ArqTxt = 'lista.txt'
#Lista = fileinput.input([ArqTxt])
