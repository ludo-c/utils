#!/bin/sh
# Returns fail2ban bans lists with fail2ban commands to reinject ban rules
# Source : mehturt from http://www.fail2ban.org/wiki/index.php/Fail2ban:Community_Portal#Question_about_persistent_IP_address_bans_over_restart
# http://blog.tanchoux.fr/2013/06/15/restauration-automatique-des-ip-bannies-par-fail2ban/

if [ "${USER}" != "root" ]; then
	echo "you must be root (or use sudo)"
	exit 1
fi

jails=$(fail2ban-client status | grep Jail\ list: | sed 's/.*Jail list:\t\+//;s/,//g')
for jail in ${jails}; do
    for ip in $(fail2ban-client status ${jail} | grep IP\ list | sed 's/.*IP list:\t//'); do
        echo "fail2ban-client set ${jail} banip ${ip}"
    done
done
