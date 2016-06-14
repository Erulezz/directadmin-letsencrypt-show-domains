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

        echo "Lets Encrypt domain: $domain";
	echo "-- Created: $created_date - $created";	
	echo "-- Renewed on: $renewal_date";
	echo "";

    fi;
done;

echo "";
echo "Lets Encrypt domains: $ledomains";

exit 0;
