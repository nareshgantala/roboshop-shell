script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "rabbitmq_appuser_password"]; then
    echo rabbitmq app user password is missing
fi


func_print_head congigure YUM repo  
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_stat_check $?

func_print_head congigure YUM repo for rabbit MQ  
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_stat_check $?

func_print_head Install rabbitmq server  
dnf install rabbitmq-server -y &>>$log_file
func_stat_check $?

func_print_head restart rabbitmq server  
systemctl enable rabbitmq-server &>>$log_file
systemctl restart rabbitmq-server &>>$log_file
func_stat_check $?

func_print_head create roboshop user   
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_stat_check $?
