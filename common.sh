app_user=roboshop

func_print_head(){
     echo -e "\e[33m<<<<<<<<<< $* >>>>>>>\e[0m"
}

func_stat_check(){
    if [ $1 -eq 0 ]; then
        echo "\e[32m<<< SUCESS>>>\e[0m"
    else
        echo "\e[31m<<< FAILURE >>>\e[0m"
        exit
    fi
}

func_schema_setup(){
    if [ "$schema_setup" == mongo ]; then

        func_print_head copy mongoDB repo file
        cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
        func_stat_check $?

        func_print_head install mongodb shell 
        dnf install mongodb-org-shell -y
        func_stat_check $?

        func_print_head Load master data of list of products 
        mongo --host mongodb-dev.cloudlife.site </app/schema/${component}.js
        func_stat_check $?

    fi

    if [ "$schema_setup" == mysql ]; then
        func_print_head Install mysql  
        dnf install mysql -y
        func_stat_check $?
 

        func_print_headLoad schema, includes countries and cities  
        mysql -h mysql-dev.cloudlife.site -uroot -p${mysql_root_password} < /app/schema/shipping.sql
        func_stat_check $?

    fi 

}

func_app_prereq(){
    func_print_head add roboshop user  
    useradd ${app_user}
    func_stat_check $?

    func_print_head create application directory
    rm -rf /app
    mkdir /app 
    
    func_print_head download application zip file  
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 
    func_stat_check $?

    cd /app 
    
    func_print_head Unzip application files  
    unzip /tmp/${component}.zip
    func_stat_check $?


}    

func_systemd_setup(){

    func_print_head "Copy ${component} service systemd file" 
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
    func_stat_check $?


    func_print_head "Restart ${component} Service" 
    systemctl daemon-reload
    systemctl enable ${component} 
    systemctl restart ${component}
    func_stat_check $?

    func_schema_setup


}

func_nodejs(){
    func_print_head "Disable current nodejs module"
    dnf module disable nodejs -y
    func_stat_check $?


    func_print_head "Enable 18 Version nodejs module"
    dnf module enable nodejs:18 -y
    func_stat_check $?


    func_print_head "Install nodejs" 
    dnf install nodejs -y
    func_stat_check $?

    
    func_app_prereq
    
    
    func_print_head "Install nodejs Dependencies" 
    npm install 
    func_stat_check $?


    func_schema_setup
    func_systemd_setup

    

}

func_java(){
    func_print_head Install maven  
    dnf install maven -y
    func_stat_check $?

    
    func_app_prereq

    func_print_head Build application  
    mvn clean package 
    mv target/shipping-1.0.jar shipping.jar 
    func_stat_check $?


    func_schema_setup
    func_systemd_setup

}