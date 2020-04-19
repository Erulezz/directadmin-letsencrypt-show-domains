# Show every domain with active Let's Encrypt certificates
Script to show all the Let's Encrypt domains that are created & managed by DirectAdmin.
Currently there is no quick way in DirectAdmin to show all the domains that are using Let's Encrypt for TLS certificates. With this script you can quickly display all the domains with their renewal date and confirm if every certificate is renewed on time. 

## Usage
Create a new file:

```
touch /usr/local/directadmin/scripts/custom/letsencrypt-show-domains.sh
cd /usr/local/directadmin/scripts/custom/
chmod 700 letsencrypt-show-domains.sh
```

Copy the contents of the script in the repo and run it as root:

```
sh letsencrypt-show-domains.sh
```
