#!/bin/bash

source components/common.sh

OS_PREREQ

Head "Installing Nginx"
apt install nginx -y &>>$LOG
Stat $?

DOWNLOAD_COMPONENT


Head "Unzip Downloaded Archive"
#unzip -o /tmp/frontend.zip &>>$LOG && cd /var/www/html && rm -rf /var/www/html/*  && mv /tmp/frontend-main/* . &&  rm -rf frontend-main README.md
#Stat $?

Head "Update Nginx Configuration"
sed -i -e "s/var/www/html/todo/frontend/dist /var/www/html" /etc/nginx/sites-available/default
stat $?


Head "Restart Nginx Service"
systemctl restart nginx
Stat $?
