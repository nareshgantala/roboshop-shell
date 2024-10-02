echo -e "\e[32m<<<<<<<<<< Install maven  >>>>>>>\e[0m"

dnf install maven -y

echo -e "\e[32m<<<<<<<<<< add roboshop user  >>>>>>>\e[0m"

useradd roboshop

echo -e "\e[32m<<<<<<<<<< copy shipping service systemd file  >>>>>>>\e[0m"

cp shipping.service /etc/systemd/system/shipping.service
rm -rf /app
mkdir /app 

echo -e "\e[32m<<<<<<<<<< download shipping zip file  >>>>>>>\e[0m"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip 
cd /app 
echo -e "\e[32m<<<<<<<<<< Unzip shipping files  >>>>>>>\e[0m"

unzip /tmp/shipping.zip
cd /app 
echo -e "\e[32m<<<<<<<<<< Build application  >>>>>>>\e[0m"

mvn clean package 
mv target/shipping-1.0.jar shipping.jar 



echo -e "\e[32m<<<<<<<<<< Install mysql  >>>>>>>\e[0m"

dnf install mysql -y 

echo -e "\e[32m<<<<<<<<<<Load schema, includes countries and cities  >>>>>>>\e[0m"

mysql -h mysql-dev.cloudlife.site -uroot -pRoboShop@1 < /app/schema/shipping.sql 


echo -e "\e[32m<<<<<<<<<< Restart shippind service  >>>>>>>\e[0m"

systemctl daemon-reload
systemctl enable shipping 
systemctl restart shipping