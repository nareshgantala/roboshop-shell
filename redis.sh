script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


func_print_head Disable current mysql  
dnf module disable mysql -y &>>$log_file
func_stat_check $?

func_print_head Install redis repo file  
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
func_stat_check $?

func_print_head Enable redis 6.2 version  
dnf module enable redis:remi-6.2 -y &>>$log_file
func_stat_check $?


func_print_head Install redis  
dnf install redis -y &>>$log_file
func_stat_check $?


func_print_head Replace 127.0.0.1 with 0.0.0.0 in redis.conf files  
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>$log_file
func_stat_check $?

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>$log_file
func_stat_check $?


func_print_head Resatrt redis  
systemctl enable redis &>>$log_file
func_stat_check $?
systemctl restart redis &>>$log_file
func_stat_check $?
