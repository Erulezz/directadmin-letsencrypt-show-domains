#!/bin/bash

ledomains=0

for san in `ls -1 /usr/local/directadmin/data/users/*/domains/*.san_config`;
do
    domain=`basename ${san}`;
    dirname=`dirname ${san}`;
    domain=${domain%.san_config};
    if [ -e "${dirname}/${domain}.cert.creation_time" ] && [ -e "${dirname}/${domain}.cert" ] && [ -e "${dirname}/${domain}.key" ];
    then
	ledomains=$[ledomains + 1];

	created=`cat ${dirname}/${domain}.cert.creation_time`;
	created_date=`date -d @$created`;
	renewal_date=`date -d "$created_date+60 days"`;
	renewal_days=$(expr '(' $created + 5184000 - $(date +%s) ')' / 86400)

        echo "Lets Encrypt domain: $domain";
	echo "-- Created: $created_date - $created";	
	echo "-- Renewal: $renewal_date";
	echo "-- Renewal in $renewal_days days.";
	echo "";

    fi;
done;

echo "";
echo "Lets Encrypt domains: $ledomains";

exit 0;
