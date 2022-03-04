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

for certificate in `ls -1 /usr/local/directadmin/data/users/*/domains/*.csr_info`;
do
    csr_info=`basename ${certificate}`;
    dirname=`dirname ${certificate}`;
    domain=${csr_info%.csr_info};

    if [ -e "${dirname}/${domain}.cert.creation_time" ] && [ -e "${dirname}/${domain}.cert" ] && [ -e "${dirname}/${domain}.key" ];
    then
	ledomains=$[ledomains + 1];

	csr_name=`cat ${dirname}/${domain}.csr_info | grep "NAME"`;
	alt_names=`openssl x509 -text -noout -in ${dirname}/${domain}.cert | grep "DNS" | tr -d ' '`;
	created=`cat ${dirname}/${domain}.cert.creation_time`;
	created_date=`LC_ALL=en_US.utf8 date -d @$created`;
	renewal_date=`LC_ALL=en_US.utf8 date -d "$created_date+$letsencrypt_renewal_days days"`;
	renewal_days=$(expr '(' $created + 5184000 - $(LC_ALL=en_US.utf8 date +%s) ')' / 86400)

        echo "${bold}Lets Encrypt domain: $domain${normal}";
	echo "CSR Name: $csr_name";
	echo "Alternative Names: $alt_names";
	echo "-- Created: $created_date - (Timestamp: $created)";
	echo "-- Renewal: $renewal_date";
	echo "-- Renewal in ~ $renewal_days days.";
	echo "";

    fi;
done;

echo "${bold}Total LetsEncrypt domains:${normal} $ledomains";
echo "";

if [ -e "/usr/local/directadmin/conf/cacert.pem.creation_time" ];
    then

	created=`cat /usr/local/directadmin/conf/cacert.pem.creation_time`;
	created_date=`LC_ALL=en_US.utf8 date -d @$created`;
	renewal_date=`LC_ALL=en_US.utf8 date -d "$created_date+$letsencrypt_renewal_days days"`;
	renewal_days=$(expr '(' $created + 5184000 - $(LC_ALL=en_US.utf8 date +%s) ')' / 86400)

        echo "---------------------------------------";
        echo "----${bold} Lets Encrypt for the Hostname${normal} ----";
        echo "---------------------------------------";
	echo $HOSTNAME;
	echo "-- Created: $created_date - $created";	
	echo "-- Renewal: $renewal_date";
	echo "-- Renewal in ~ $renewal_days days.";
	echo "";

fi;

exit 0;
