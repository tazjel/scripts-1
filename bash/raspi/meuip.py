#!/usr/bin/python

import subprocess
import smtplib
import socket
from email.mime.text import MIMEText
import urllib
import re

to = 'rabelo@raphaelr.com.br'
gmail_user = 'meuip@raphaelr.com.br'
gmail_password = 'KJAIeh93nu@(G13'
smtpserver = smtplib.SMTP('smtp.gmail.com', 587)
smtpserver.ehlo()
smtpserver.starttls()
smtpserver.ehlo
smtpserver.login(gmail_user, gmail_password)

ipaddr = urllib.urlopen("http://icanhazip.com").read()
msg = MIMEText(ipaddr)
msg['Subject'] = ipaddr
msg['From'] = gmail_user
msg['To'] = to
smtpserver.sendmail(gmail_user, [to], msg.as_string())
smtpserver.quit()
