script_path=$(dirname $0)
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "mysql_root_password"]; then
    echo mysql password is missing
fi



echo -e "\e[32m<<<<<<<<<< Disable current mysql  >>>>>>>\e[0m"

dnf module disable mysql -y 
echo -e "\e[32m<<<<<<<<<< copy mysql repo  >>>>>>>\e[0m"

cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[32m<<<<<<<<<< install mysql server  >>>>>>>\e[0m"

dnf install mysql-community-server -y

echo -e "\e[32m<<<<<<<<<< start mysqld  >>>>>>>\e[0m"

systemctl enable mysqld
systemctl start mysqld  

echo -e "\e[32m<<<<<<<<<< change default root password >>>>>>>\e[0m"

mysql_secure_installation --set-root-pass RoboShop@1
