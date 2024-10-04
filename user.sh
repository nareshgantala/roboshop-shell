script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user
func_nodejs



echo -e "\e[32m<<<<<<<<<< Install mongo shell >>>>>>>\e[0m"

dnf install mongodb-org-shell -y
mongo --host mongodb-dev.cloudlife.site </app/schema/user.js
