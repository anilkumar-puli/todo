#!/bin/bash

source components/common.sh

OS_PREREQ

Head "Install Maven"
apt install maven -y &>>$LOG
Stat $?


Head "Adding todoapp User"
id todoapp &>>$LOG
if [ $? -ne 0 ]; then
  useradd -m -s /bin/bash todoapp
  Stat $?
fi

DOWNLOAD_COMPONENT

Head "Extract Downloaded Archive"
cd /home/todoapp && rm -rf todoapp
 && unzip -o /tmp/todo.zip &>>$LOG && mv todo-main todo && cd /home/todoapp/todo &&  mvn clean package  &>>$LOG && chown todoapp:todoapp /home/todoapp -R && mv target/shipping-1.0.jar shipping.jar  &>>$LOG
Stat $?

Head "Update EndPoints in Service File"
sed -i -e "s/CARTENDPOINT/cart.zsdevops01.online/" -e "s/DBHOST/mysql.zsdevops01.online/" /home/roboshop/shipping/systemd.service
Stat $?


Head "Setup SystemD Service"
mv /home/todoapp/todo/systemd.service /etc/systemd/system/todo.service && systemctl daemon-reload && systemctl start todo && systemctl enable todo &>>$LOG
Stat $?