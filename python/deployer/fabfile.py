from fabric.api import *

env.user = 'root'

env.roledefs = {
	'valid_web' : ['web-valid-site'],
	'valid_db' : ['web-valid-mysql01', 'web-valid-mysql02'],
	'preprod_web' : ['web-preprod-site'],
	'preprod_db' : ['web-preprod-mysql01', 'web-preprod-mysql02']
}

@roles('valid_web', 'preprod_web')
def copy():
	run('mkdir -p /tmp/valor/online')
	put('/var/www/valor/online', '/tmp/valor/')

@roles('valid_db', 'preprod_db')
def fnDb():
	run('hostname')
