script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

echo -e "\e[32m<<<<<<<<<< Install python 3.6, and some dependencies  >>>>>>>\e[0m"

dnf install python36 gcc python3-devel -y

echo -e "\e[32m<<<<<<<<<< create roboshop user  >>>>>>>\e[0m"

useradd ${app_user}

echo -e "\e[32m<<<<<<<<<< copy payment service systemd file  >>>>>>>\e[0m"

sed -i -e "s/rabbitmq_appuser_password/${rabbitmq_appuser_password}" ${script_path}/payment.service

cp ${script_path}/payment.service /etc/systemd/system/payment.service
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
