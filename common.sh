app_user=roboshop

func_nodejs(){
    echo -e "\e[32m<<<<<<<<<< Disable current nodejs module>>>>>>>\e[0m"

    dnf module disable nodejs -y

    echo -e "\e[32m<<<<<<<<<< Enable 18 Version nodejs module>>>>>>>\e[0m"

    dnf module enable nodejs:18 -y

    echo -e "\e[32m<<<<<<<<<< Install nodejs >>>>>>>\e[0m"

    dnf install nodejs -y

    echo -e "\e[32m<<<<<<<<<< Copy ${component} service systemd file >>>>>>>\e[0m"

    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

    echo -e "\e[32m<<<<<<<<<< Create roboshop user >>>>>>>\e[0m"

    useradd ${app_user}
    rm -rf /app
    mkdir /app 

    echo -e "\e[32m<<<<<<<<<< Download ${component} zip file >>>>>>>\e[0m"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip 
    cd /app 

    echo -e "\e[32m<<<<<<<<<< Unzip ${component} files >>>>>>>\e[0m"

    unzip /tmp/${component}.zip

    cd /app 
    echo -e "\e[32m<<<<<<<<<< Install nodejs Dependencies >>>>>>>\e[0m"

    npm install 

    echo -e "\e[32m<<<<<<<<<< Restart ${component} Service >>>>>>>\e[0m"

    systemctl daemon-reload
    systemctl enable ${component} 
    systemctl restart ${component}

}