script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


func_print_head Install nginx 
dnf install nginx -y &>>$log_file
func_stat_check $?

func_print_head copy roboshop config file 
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_stat_check $?


func_print_head Remove the defult content 
rm -rf /usr/share/nginx/html/* &>>$log_file
func_stat_check $?

func_print_head Download front end zip file 
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_stat_check $?

func_print_head move to html folder
cd /usr/share/nginx/html &>>$log_file
func_stat_check $?

func_print_head unzip front end file 
unzip /tmp/frontend.zip &>>$log_file
func_stat_check $?

func_print_head Restart front end Service #some file needs to be created
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
func_stat_check $?