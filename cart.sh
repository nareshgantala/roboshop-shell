echo -e "\e[32m<<<<<<<<<< Disable current nodejs module>>>>>>>\e[0m"

dnf module disable nodejs -y

echo -e "\e[32m<<<<<<<<<< Enable 18 Version nodejs module>>>>>>>\e[0m"

dnf module enable nodejs:18 -y

echo -e "\e[32m<<<<<<<<<< Install nodejs >>>>>>>\e[0m"

dnf install nodejs -y

echo -e "\e[32m<<<<<<<<<< Copy cart service systemd file >>>>>>>\e[0m"

cp cart.service /etc/systemd/system/cart.service

echo -e "\e[32m<<<<<<<<<< Create roboshop user >>>>>>>\e[0m"

useradd roboshop
mkdir /app 

echo -e "\e[32m<<<<<<<<<< Download cart zip file >>>>>>>\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip 
cd /app 

echo -e "\e[32m<<<<<<<<<< Unzip cart files >>>>>>>\e[0m"

unzip /tmp/cart.zip

cd /app 
echo -e "\e[32m<<<<<<<<<< Install nodejs Dependencies >>>>>>>\e[0m"

npm install 

echo -e "\e[32m<<<<<<<<<< Restart Cart Service >>>>>>>\e[0m"

systemctl daemon-reload
systemctl enable cart 
systemctl start cart
