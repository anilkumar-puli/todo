#!/bin/bash

source components/common.sh

OS_PREREQ

Head "Adding login User"
id loginuser &>>$LOG
if [ $? -ne 0 ]; then
  useradd -m -s /bin/bash loginuser
  Stat $?
fi

DOWNLOAD_COMPONENT

Head "Extract Downloaded Archive"
cd /home/loginuser && unzip -o /tmp/login.zip &>>$LOG && mv login-main login && chown loginuser:loginuser /home/loginuser -R &&  cd /home/loginuser/login && mkdir go/src &&export GOPATH=/go && go get &&
go build 
Stat $?

Head "Update EndPoints in Service File"
#sed -i -e "s/CARTENDPOINT/cart.zsdevops01.online/" -e "s/DBHOST/mysql.zsdevops01.online/" /home/roboshop/shipping/systemd.service
Stat $?


Head "Setup SystemD Service"
mv /home/loginuser/login/systemd.service /etc/systemd/system/login.service && systemctl daemon-reload && systemctl start login && systemctl enable login &>>$LOG
Stat $?