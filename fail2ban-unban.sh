#!/bin/sh
# Remove an IP blocked by fail2ban.

chain="f2b-sshd"
jail="sshd"

if [ "${USER}" != "root" ]; then
	echo "you must be root (or use sudo)"
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "Wrong parameters"
	echo "usage: $0 @IP"
	exit 2
fi

total=$(iptables -L ${chain} -n --line-number | grep REJECT | tail -n1 | awk '{print $1}')
echo "There is ${total} rules for ${chain}"

output=$(iptables -L ${chain} -n --line-number | grep $1)
if [ $? -ne 0 ]; then
	echo "IP does not match"
else
	number=$(echo ${output} | awk '{print $1}')
	echo "You will remove rule ${number}:"
	echo "${output}" | head -n1
	echo -n "Are you sure (yes/NO) ? "
	read dummy
	if [ "${dummy}" = "yes" ]; then
		#iptables -D ${chain} ${number}
		#[ $? -eq 0 ] && echo "successfully removed" || echo "error while removing iptables rule"
		fail2ban-client set ${jail} unbanip $1
		[ $? -eq 0 ] && echo "successfully removed" || echo "error while removing iptables rule"
	else
		echo "Abort"
		exit 3
	fi
fi
