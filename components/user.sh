#!/bin/bash

source components/common.sh

OS_PREREQ

Head "Install Maven and java"
apt install openjdk-8-jdk -y &>>$LOG
apt install maven -y &>>$LOG
Stat $?

DOWNLOAD_COMPONENT
Head "Extract Downloaded Archive"
cd /home/ubuntu && rm -rf user && unzip -o /tmp/user.zip &>>$LOG && mv user-main user && cd /home/ubuntu/user &&  cd /home/ubuntu/user &&  mvn clean package  &>>$LOG && chown ubuntu:ubuntu /home/ubuntu -R && mv target/user-1.0.jar user.jar  &>>$LOG
Stat $?

Head "Update EndPoints in Service File"
sed -i -e "s/user_endpoint/login.anilzs.ml/" /home/ubuntu/user/systemd.service
Stat $?


Head "Setup SystemD Service"
mv /home/ubuntu/user/systemd.service /etc/systemd/system/user.service && systemctl daemon-reload && systemctl start user && systemctl enable user &>>$LOG
Stat $?