#!/usr/bin/expect
# 1:slave_ip 2:slave_password
set slave_ip [lindex $argv 0]
set slave_password [lindex $argv 1]
set timeout 300

# Send slave.host
spawn scp ./tmp/slave.host root@$slave_ip:/root
expect {
"yes/no" { send "yes\r";exp_continue }
"password:" { send "$slave_password\r" }
}
expect "100%"

# Send hadoop.master.tar.gz
spawn scp ./tmp/hadoop.master.tar.gz root@$slave_ip:/root
expect {
"yes/no" { send "yes\r";exp_continue }
"password:" { send "$slave_password\r" }
}
expect "100%"

# Send id_rsa.pub
spawn scp ./tmp/id_rsa.pub root@$slave_ip:/root
expect {
"yes/no" { send "yes\r";exp_continue }
"password:" { send "$slave_password\r" }
}
expect "100%"

# Send prework.sh
spawn scp ./tmp/prework.sh root@$slave_ip:/root
expect {
"yes/no" { send "yes\r";exp_continue }
"password:" { send "$slave_password\r" }
}
expect "100%"

# Send slave.sh
spawn scp ./slave.sh root@$slave_ip:/root
expect {
"yes/no" { send "yes\r";exp_continue }
"password:" { send "$slave_password\r" }
}
expect "100%"

# Send setup.conf
spawn scp ./setup.conf root@$slave_ip:/root
expect {
"yes/no" { send "yes\r";exp_continue }
"password:" { send "$slave_password\r" }
}
expect "100%"

# Call slave.sh
spawn ssh root@$slave_ip
expect {
"yes/no" { send "yes\r";exp_continue }
"password:" { send "$slave_password\r" }
}
expect "*#*"
send "cd ~\r"
expect "*#*"
send "chmod +x slave.sh\r"
expect "*#*"
send "./slave.sh\r"
expect "I'm SLAVED!"