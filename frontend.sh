script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


echo -e "\e[32m<<<<<<<<<< Install nginx >>>>>>>\e[0m"

dnf install nginx -y 

echo -e "\e[32m<<<<<<<<<< copy roboshop config file >>>>>>>\e[0m"

cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf


echo -e "\e[32m<<<<<<<<<< Remove the defult content >>>>>>>\e[0m"

rm -rf /usr/share/nginx/html/* 

echo -e "\e[32m<<<<<<<<<< Download front end zip file >>>>>>>\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 
cd /usr/share/nginx/html 

echo -e "\e[32m<<<<<<<<<< unzip front end file >>>>>>>\e[0m"
unzip /tmp/frontend.zip

echo -e "\e[32m<<<<<<<<<< Restart front end Service >>>>>>>\e[0m"
#some file needs to be created
systemctl enable nginx 
systemctl restart nginx 