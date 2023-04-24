#!/usr/bin/expect
# -d for debug 

eval spawn /opt/cisco/anyconnect/bin/vpn connect <<<HOST>>>

set p [exec /usr/bin/security find-generic-password -ws bse-cisco-vpn]
set u [exec echo $USER]

expect "Username: " { send $u\r }
expect "Password: " { send $p\r }


expect -re "(.*accept\?.*)" { send "y\r" }

set timeout 20
expect "VPN>"
