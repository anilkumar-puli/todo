#!/bin/bash

source components/common.sh

OS_PREREQ

Head "Installing Nginx"
apt install nginx -y &>>$LOG
Stat $?

DOWNLOAD_COMPONENT


Head "Unzip Downloaded Archive"
cd /var/www/html && unzip -o /tmp/frontend.zip &>>$LOG && mv frontend-main/* . && rm -rf frontend-main README.md
Stat $?

Head "Update Nginx Configuration"
echo "var/www/html" | sed 's/var/www/html/todo/frontend/dist'
#sed -i -e "s/var/www/html/todo/frontend/dist var/www/html" /etc/nginx/sites-available/default
stat $?


Head "Restart Nginx Service"
systemctl restart nginx
Stat $?
