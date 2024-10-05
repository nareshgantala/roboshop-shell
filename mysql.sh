script_path=$(dirname $0)
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "mysql_root_password" ]; then
    echo mysql password is missing
fi


func_print_head Disable current mysql  
dnf module disable mysql -y &>>$log_file
func_stat_check $?

func_print_head copy mysql repo  
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_stat_check $?

func_print_head install mysql server  
dnf install mysql-community-server -y &>>$log_file
func_stat_check $?

func_print_head start mysqld  
systemctl enable mysqld &>>$log_file
systemctl start mysqld  &>>$log_file
func_stat_check $?

func_print_head change default root password 
mysql_secure_installation --set-root-pass RoboShop@1 &>>$log_file
func_stat_check $?
