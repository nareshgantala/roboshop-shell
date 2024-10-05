app_user=roboshop
log_file=/tmp/roboshop.log

func_print_head(){
     echo -e "\e[33m<<<<<<<<<< $* >>>>>>>\e[0m"
     echo -e "\e[33m<<<<<<<<<< $* >>>>>>>\e[0m" &>>$log_file

}

func_stat_check(){
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m<<< SUCESS>>>\e[0m"
    else
        echo -e "\e[31m<<< FAILURE >>>\e[0m"
        exit
    fi
}


func_schema_setup(){
    if [ "$schema_setup" = mongo ]; then

        func_print_head copy mongoDB repo file
        cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
        func_stat_check $?

        func_print_head install mongodb shell 
        dnf install mongodb-org-shell -y &>>$log_file
        func_stat_check $?

        func_print_head Load master data of list of products 
        mongo --host mongodb-dev.cloudlife.site </app/schema/${component}.js &>>$log_file
        func_stat_check $?

    fi

    if [ "$schema_setup" = mysql ]; then
        func_print_head Install mysql  
        dnf install mysql -y &>>$log_file
        func_stat_check $?
 

        func_print_head Load schema, includes countries and cities  
        mysql -h mysql-dev.cloudlife.site -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>$log_file
        func_stat_check $?

    fi 

}

func_app_prereq(){
    id ${app_user} &>>$log_file

    if [ $? -ne 0 ]; then
        func_print_head add roboshop user  
        useradd ${app_user} &>>$log_file
        func_stat_check $?
    else
        func_print_head add roboshop user  
        echo skipping user creation, as roboshop user already exists
    fi

    func_print_head create application directory
    rm -rf /app &>>$log_file
    mkdir /app &>>$log_file
    func_stat_check $?
    
    func_print_head download application zip file  
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    func_stat_check $?

    cd /app 
    
    func_print_head Unzip application files  
    unzip /tmp/${component}.zip &>>$log_file
    func_stat_check $?


}    

func_systemd_setup(){

    func_print_head "Copy ${component} service systemd file" 
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    func_stat_check $?


    func_print_head "Restart ${component} Service" 
    systemctl daemon-reload &>>$log_file
    systemctl enable ${component} &>>$log_file
    systemctl restart ${component} &>>$log_file
    func_stat_check $?

    func_schema_setup


}

func_nodejs(){
    func_print_head "Disable current nodejs module"
    dnf module disable nodejs -y &>>$log_file
    func_stat_check $?


    func_print_head "Enable 18 Version nodejs module"
    dnf module enable nodejs:18 -y &>>$log_file
    func_stat_check $?


    func_print_head "Install nodejs" 
    dnf install nodejs -y &>>$log_file
    func_stat_check $?

    
    func_app_prereq
    
    
    func_print_head "Install nodejs Dependencies" 
    npm install &>>$log_file
    func_stat_check $?
    
    func_print_head debug code
    echo "schema_setup is set to: $schema_setup"


    func_schema_setup
    func_systemd_setup
    
}

func_java(){
    func_print_head Install maven  
    dnf install maven -y &>>$log_file
    func_stat_check $?

    
    func_app_prereq

    func_print_head Build application  
    mvn clean package &>>$log_file
    mv target/shipping-1.0.jar shipping.jar &>>$log_file
    func_stat_check $?


    func_schema_setup
    func_systemd_setup

}

func_python(){

    func_print_head Install python 3.6, and some dependencies  
    dnf install python36 gcc python3-devel -y &>>$log_file
    func_stat_check $?

    func_app_prereq

    func_print_head copy rabbitmq password in payment service file
    sed -i -e "s/rabbitmq_appuser_password/${rabbitmq_appuser_password}/" ${script_path}/payment.service &>>$log_file
    func_stat_check $?


    func_print_head Install python requirements 
    pip3.6 install -r requirements.txt &>>$log_file
    func_stat_check $?

    func_systemd_setup
 
}

func_golang(){
    func_print_head Install golang 
    dnf install golang -y &>>$log_file
    func_stat_check $?

    func_app_prereq

    func_print_head running go get, build commands 
    go mod init dispatch &>>$log_file
    func_stat_check $?

    go get &>>$log_file
    func_stat_check $?
 
    go build &>>$log_file
    func_stat_check $?

    func_systemd_setup
}