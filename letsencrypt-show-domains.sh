#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

ledomains=0
letsencrypt_renewal_days=`/usr/local/directadmin/directadmin c | grep ^letsencrypt_renewal_days= | cut -d\= -f2`
account_email=`cat /usr/local/directadmin/data/users/admin/user.conf | grep ^email= | cut -d\= -f2`

echo "--------------------------------------------------";
echo "-------------- ${bold}General Information${normal} ---------------";
echo "--------------------------------------------------";
echo "";
echo "${bold}LetsEncrypt renewal days (DirectAdmin config):${normal} $letsencrypt_renewal_days";
echo "${bold}LetsEncrypt Account Email:${normal} $account_email";
echo "";
echo "--------------------------------------------------";
echo "--------- ${bold}User LetsEncrypt certificates${normal} ----------";
echo "--------------------------------------------------";
echo "";

for san in `ls -1 /usr/local/directadmin/data/users/*/domains/*.san_config`;
do
    domain=`basename ${san}`;
    dirname=`dirname ${san}`;
    domain=${domain%.san_config};
    if [ -e "${dirname}/${domain}.cert.creation_time" ] && [ -e "${dirname}/${domain}.cert" ] && [ -e "${dirname}/${domain}.key" ];
    then
	ledomains=$[ledomains + 1];

	sanconfig=`cat ${dirname}/${domain}.san_config | grep "subjectAltName"`;
	created=`cat ${dirname}/${domain}.cert.creation_time`;
	created_date=`LC_ALL=en_US.utf8 date -d @$created`;
	renewal_date=`LC_ALL=en_US.utf8 date -d "$created_date+$letsencrypt_renewal_days days"`;
	renewal_days=$(expr '(' $created + 5184000 - $(LC_ALL=en_US.utf8 date +%s) ')' / 86400)

        echo "${bold}Lets Encrypt domain: $domain${normal}";
	echo "$sanconfig";
	echo "-- Created: $created_date - $created";	
	echo "-- Renewal: $renewal_date";
	echo "-- Renewal in ~ $renewal_days days.";
	echo "";

    fi;
done;

echo "${bold}Total LetsEncrypt domains:${normal} $ledomains";
echo "";

if [ -e "/usr/local/directadmin/conf/cacert.pem.creation_time" ];
    then

	sanconfig=`cat /usr/local/directadmin/conf/ca.san_config | grep "subjectAltName"`;
	created=`cat /usr/local/directadmin/conf/cacert.pem.creation_time`;
	created_date=`LC_ALL=en_US.utf8 date -d @$created`;
	renewal_date=`LC_ALL=en_US.utf8 date -d "$created_date+$letsencrypt_renewal_days days"`;
	renewal_days=$(expr '(' $created + 5184000 - $(LC_ALL=en_US.utf8 date +%s) ')' / 86400)

        echo "---------------------------------------";
        echo "----${bold} Lets Encrypt for the Hostname${normal} ----";
        echo "---------------------------------------";
	echo "$sanconfig";
	echo "-- Created: $created_date - $created";	
	echo "-- Renewal: $renewal_date";
	echo "-- Renewal in ~ $renewal_days days.";
	echo "";

fi;

exit 0;
