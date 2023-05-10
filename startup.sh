#!/bin/bash

password="$(openssl rand -base64 15)";

echo "rstudio:$password" | chpasswd
echo "The password for the rstudio user is: $password"
echo "Login to the webui @ https://localhost:8787"

uuidgen -x | tr -d '-' > /etc/rstudio/secure-cookie-key

/usr/lib/rstudio-server/bin/rserver --server-daemonize=0  --www-port=8787 --auth-cookies-force-secure=1
