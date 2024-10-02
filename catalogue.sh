source common.sh

echo -e "\e[32m<<<<<<<<<< Disable current nodejs module>>>>>>>\e[0m"

dnf module disable nodejs -y

echo -e "\e[32m<<<<<<<<<< Enable 18 Version nodejs module>>>>>>>\e[0m"

dnf module enable nodejs:18 -y

echo -e "\e[32m<<<<<<<<<< Install nodejs >>>>>>>\e[0m"

dnf install nodejs -y

echo -e "\e[32m<<<<<<<<<< Copy catalogue service systemd file >>>>>>>\e[0m"

cp catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[32m<<<<<<<<<< Copy mongodb repo >>>>>>>\e[0m"


cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m<<<<<<<<<< Create roboshop user >>>>>>>\e[0m"

useradd ${app_user}
rm -rf /app
mkdir /app 

echo -e "\e[32m<<<<<<<<<< Download Catlogue zip file >>>>>>>\e[0m"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip 
cd /app 

echo -e "\e[32m<<<<<<<<<< Unzip catalogue files >>>>>>>\e[0m"

unzip /tmp/catalogue.zip
cd /app 

echo -e "\e[32m<<<<<<<<<< Install nodejs Dependencies >>>>>>>\e[0m"

npm install 
echo -e "\e[32m<<<<<<<<<< Restart catalogue Service >>>>>>>\e[0m"

systemctl daemon-reload
systemctl enable catalogue 
systemctl restart catalogue

echo -e "\e[32m<<<<<<<<<< install mongodb shell >>>>>>>\e[0m"

dnf install mongodb-org-shell -y

echo -e "\e[32m<<<<<<<<<< Load master data of list of products >>>>>>>\e[0m"

mongo --host mongodb-dev.cloudlife.site </app/schema/catalogue.js