script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[32m<<<<<<<<<< Install redis repo file  >>>>>>>\e[0m"

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
echo -e "\e[32m<<<<<<<<<< Enable redis 6.2 version  >>>>>>>\e[0m"

dnf module enable redis:remi-6.2 -y

echo -e "\e[32m<<<<<<<<<< Install redis  >>>>>>>\e[0m"

dnf install redis -y 

echo -e "\e[32m<<<<<<<<<< Replace 127.0.0.1 with 0.0.0.0 in redis.conf files  >>>>>>>\e[0m"

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf

echo -e "\e[32m<<<<<<<<<< Resatrt redis  >>>>>>>\e[0m"

systemctl enable redis 
systemctl restart redis 