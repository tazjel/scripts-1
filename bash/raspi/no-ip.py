#!/usr/bin/python

import urllib

myurl = "rabeloo.myftp.org"
username = "rabeloo@gmail.com"
password = ""

web_page = urllib.urlopen("http://iptools.bizhat.com/ipv4.php")
myip = web_page.read()

print "Seu ip: " + myip + "\n"

update_url = "http://" + username + ":" + password + "@dynupdate.no-ip.com/nic/update?hostname=" + myurl + "&myip=" + myip

print update_url + "\n"

print urllib.urlopen(update_url).read()
