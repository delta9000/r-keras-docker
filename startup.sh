#!/bin/bash


password="$(openssl rand -base64 15)";

echo "rstudio:$password" | chpasswd
echo "The password for the rstudio user is: $password"


service rstudio-server stop


/usr/lib/rstudio-server/bin/rserver --server-daemonize=0  --www-port=8787
