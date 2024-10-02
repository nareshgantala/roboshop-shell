script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[32m<<<<<<<<<< copy mongodb repo >>>>>>>\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m<<<<<<<<<< Install mongodb org >>>>>>>\e[0m"
dnf install mongodb-org -y 

echo -e "\e[32m<<<<<<<<<< Replace 127.0.0.1 with 0.0.0.0  >>>>>>>\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

echo -e "\e[32m<<<<<<<<<< Restart mongod  >>>>>>>\e[0m"

systemctl enable mongod 
systemctl restart mongod 