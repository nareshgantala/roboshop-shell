app_user=roboshop

print_head(){
     echo -e "\e[32m<<<<<<<<<< $* >>>>>>>\e[0m"
}

func_nodejs(){
    print_head "Disable current nodejs module"

    dnf module disable nodejs -y

    print_head "Enable 18 Version nodejs module"

    dnf module enable nodejs:18 -y

    print_head "Install nodejs" 

    dnf install nodejs -y

    print_head "Copy ${component} service systemd file" 

    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

    print_head "Create roboshop user" 

    useradd ${app_user}
    rm -rf /app
    mkdir /app 

    print_head "Download ${component} zip file" 
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 
    cd /app 

    print_head "Unzip ${component} files" 

    unzip /tmp/${component}.zip

    cd /app 
    print_head "Install nodejs Dependencies" 

    npm install 

    print_head "Restart ${component} Service" 

    systemctl daemon-reload
    systemctl enable ${component} 
    systemctl restart ${component}

}