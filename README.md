# Show every domain with active Let's Encrypt certificates
Script to show all the Let's Encrypt domains that are created & managed by DirectAdmin.
Currently there is no quick way in DirectAdmin to show all the domains that are using Let's Encrypt for TLS certificates. With this script you can quickly display all the domains with their renewal date and confirm if every certificate is renewed on time. 

## Usage
Download the script and set permissions:

```
wget https://raw.githubusercontent.com/Erulezz/directadmin-letsencrypt-show-domains/master/letsencrypt-show-domains.sh -O /usr/local/directadmin/scripts/custom/letsencrypt-show-domains.sh
chmod 700 /usr/local/directadmin/scripts/custom/letsencrypt-show-domains.sh
```

Test the script

```
cd /usr/local/directadmin/scripts/custom/
sh letsencrypt-show-domains.sh
```
