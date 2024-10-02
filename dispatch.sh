script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[32m<<<<<<<<<< Install golang >>>>>>>\e[0m"

dnf install golang -y

echo -e "\e[32m<<<<<<<<<< Create roboshop user >>>>>>>\e[0m"

useradd ${app_user}
echo -e "\e[32m<<<<<<<<<< Copy dispatch service systemd file >>>>>>>\e[0m"


cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service
rm -rf /app
mkdir /app 

echo -e "\e[32m<<<<<<<<<< Download dispatch zip file >>>>>>>\e[0m"

curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip 
cd /app 

echo -e "\e[32m<<<<<<<<<< Unzip dispatch files >>>>>>>\e[0m"

unzip /tmp/dispatch.zip
cd /app 

echo -e "\e[32m<<<<<<<<<< running go get, build commands >>>>>>>\e[0m"

go mod init dispatch
go get 
go build

echo -e "\e[32m<<<<<<<<<< Restart dispatch Service >>>>>>>\e[0m"

systemctl daemon-reload
systemctl enable dispatch 
systemctl start dispatch