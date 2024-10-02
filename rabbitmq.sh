script_path=$(dirname $0)
source ${script_path}/common.sh

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

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"