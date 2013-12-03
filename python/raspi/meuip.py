#!/usr/bin/python

import subprocess
import smtplib
import socket
import fcntl
import struct
from email.MIMEText import MIMEText
import urllib
import re

# Email To:
to_mail = 'rabelo@raphaelr.com.br'

# Server Settings
from_mail = 'meuip@raphaelr.com.br'
from_passwd = ''
server = smtplib.SMTP('smtp.gmail.com', 587)
server.ehlo()
server.starttls()
server.ehlo
server.login(from_mail, from_passwd)

def get_int_ip(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])

# Getting IP's
intaddr = get_int_ip('eth0')
extaddr = urllib.urlopen("http://icanhazip.com").read()

# Sending email ...
msg_text="Internal IP: %s \nExternal IP: %s" % (intaddr,extaddr)
print msg_text
msg = MIMEText(msg_text)
msg['From'] = from_mail
msg['To'] = to_mail
msg['Subject'] = "[Raspi] My ip"

print msg
server.sendmail(from_mail, [to_mail], msg.as_string())
server.quit()
