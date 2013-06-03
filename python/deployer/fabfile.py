from fabric.api import *

env.user = 'root'
env.warn_only=True

localPath = '/tmp/_valor_online.tmp/online/'
remotePath = '/var/www/valor/'

env.roledefs = {
	'teste_web'		:	['localhost'],
	'valid_web'		:	['web-valid-site'],
	'preprod_web'	:	['web-preprod-site'],
	'teste_db'		:	['localhost'],
#	'prod_web'		:	['www10','www11','www12','www13'],
	'valid_db'		:	['web-valid-mysql01'],
	'preprod_db'	:	['web-preprod-mysql01']
}

def cmd(cmd):
	run(cmd)
	
@roles('teste_web')
def deploy():
	with settings(warn_only=True):
		put(localPath, remotePath)
		local('rm -rf %s' % localPath)

def backup():
	with settings(warn_only=True):
		print "\tMaking backup..."
#		run('tar ...')

def dump():
	with settings(warn_only=True):
		print "\tMaking dump..."
#		run('mysqldump ... ')