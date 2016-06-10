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
        echo "Lets Encrypt domain: $domain";
    fi;
done;

echo "";
echo "Lets Encrypt domains: $ledomains";

exit 0;
