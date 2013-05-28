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

def fnExtract(txtFile):
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
# Add required=1 on -e
parser.add_argument('-e', '--environment', nargs='+', action='store', help='Environment to apply the package files.')
parser.add_argument('-l', '--list', nargs='+', action='store', help='List of files do deploy' )
parser.add_argument('-b', '--backup', action='store_false', help='Make backup of files.')
parser.add_argument('-u', '--dump', action='store_false', help='Make database dumping.')
args = parser.parse_args()
print "\nARGUMENTS:\n\t%r\n" % args

env = args.environment

if args.backup == False:
	fnBackup()
if args.dump == False:
	fnDump()

if fnExtract(args.list) == True:
	os.system('fab fnWeb')
else:
	exit(1)

## Read file line by line
#ArqTxt = 'lista.txt'
#Lista = fileinput.input([ArqTxt])
