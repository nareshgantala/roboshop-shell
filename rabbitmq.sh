script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "rabbitmq_appuser_password"]; then
    echo rabbitmq app user password is missing
fi


echo -e "\e[32m<<<<<<<<<< congigure YUM repo  >>>>>>>\e[0m"

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
echo -e "\e[32m<<<<<<<<<< congigure YUM repo for rabbit MQ  >>>>>>>\e[0m"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[32m<<<<<<<<<< Install rabbitmq server  >>>>>>>\e[0m"

dnf install rabbitmq-server -y 

echo -e "\e[32m<<<<<<<<<< restart rabbitmq server  >>>>>>>\e[0m"

systemctl enable rabbitmq-server 
systemctl restart rabbitmq-server 

echo -e "\e[32m<<<<<<<<<< create roboshop user   >>>>>>>\e[0m"

rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"