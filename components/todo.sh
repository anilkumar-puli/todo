#!/bin/bash

source components/common.sh

cd OS_PREREQs
Head "Installing npm"
apt install npm -y &>>$LOG
Stat $?

DOWNLOAD_COMPONENT
Head "extracting Downloaded Archive"
cd /home/ubuntu && rm -rf todo && unzip -o /tmp/todo.zip &>>$LOG && mv todo-main todo && cd /home/ubuntu/todo && npm install && npm start
Stat $?

Head "Update EndPoints in Service File"
sed -i -e "s/user_endpoint/todo.anilzs.ml/" /home/ubuntu/todo/systemd.service
Stat $?

Head "Setup SystemD Service"
mv /home/ubuntu/todo/systemd.service /etc/systemd/system/todo.service && systemctl daemon-reload && systemctl start todo && systemctl enable todo &>>$LOG
Stat $?