#!/bin/bash

if [ -n "$1" ]; then
  password="$1"
else
  password="$(openssl rand -base64 15)"
fi

if [ ${#password} -lt 8 ] || ! [[ $password =~ [[:upper:]] ]] || ! [[ $password =~ [[:lower:]] ]] || ! [[ $password =~ [[:digit:]] ]]; then
  echo "Error: Password does not meet complexity requirements."
  echo "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit."
  exit 1
fi

echo "rstudio:$password" | chpasswd
echo "The password for the rstudio user is: $password"
echo "Login to the webui @ http://localhost:8787"


openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/ssl/self-signed.key -out /etc/ssl/self-signed.crt -subj "/CN=localhost"


uuidgen -x | tr -d '-' > /etc/rstudio/secure-cookie-key


cat << EOF >> Caddyfile
{ 
admin off 
}
 
:8787 {
    tls /etc/ssl/self-signed.crt /etc/ssl/self-signed.key 
    reverse_proxy 127.0.0.1:8786
}
EOF

caddy start &> caddy-log

/usr/lib/rstudio-server/bin/rserver --server-daemonize=0  --www-port=8786
