source common.sh

echo -e "\e[32m<<<<<<<<<< Install python 3.6, and some dependencies  >>>>>>>\e[0m"

dnf install python36 gcc python3-devel -y

echo -e "\e[32m<<<<<<<<<< create roboshop user  >>>>>>>\e[0m"

useradd ${app_user}

echo -e "\e[32m<<<<<<<<<< copy payment service systemd file  >>>>>>>\e[0m"

cp payment.service /etc/systemd/system/payment.service
rm -rf /app
mkdir /app 

echo -e "\e[32m<<<<<<<<<< Download payment zip file  >>>>>>>\e[0m"

curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip 
cd /app 

echo -e "\e[32m<<<<<<<<<< Unzip payment zip files  >>>>>>>\e[0m"

unzip /tmp/payment.zip
cd /app 

echo -e "\e[32m<<<<<<<<<< Install python requirements  >>>>>>>\e[0m"

pip3.6 install -r requirements.txt

echo -e "\e[32m<<<<<<<<<< restart payment service  >>>>>>>\e[0m"

systemctl daemon-reload
systemctl enable payment 
systemctl restart payment
