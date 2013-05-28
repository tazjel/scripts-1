from fabric.api import *

env.user = 'root'
localPath = '/tmp/_valor_online.tmp/*'
remotePath = '/var/www/valor/online'
env.roledefs = {
	'teste_web' : ['localhost']
#	'valid_web' : ['web-valid-site'],
#	'valid_db' : ['web-valid-mysql01', 'web-valid-mysql02'],
#	'preprod_web' : ['web-preprod-site'],
#	'preprod_db' : ['web-preprod-mysql01', 'web-preprod-mysql02']
}

@roles('teste_web')
def fnWeb():
	put(localPath, remotePath)

@roles('teste_db')
def fnDb():
	run('hostname')
