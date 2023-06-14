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

uuidgen -x | tr -d '-' > /etc/rstudio/secure-cookie-key

/usr/lib/rstudio-server/bin/rserver --server-daemonize=0  --www-port=8787 --auth-cookies-force-secure=1
