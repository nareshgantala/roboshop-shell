script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=catalogue
func_nodejs

echo -e "\e[32m<<<<<<<<<< install mongodb shell >>>>>>>\e[0m"

dnf install mongodb-org-shell -y

echo -e "\e[32m<<<<<<<<<< Load master data of list of products >>>>>>>\e[0m"

mongo --host mongodb-dev.cloudlife.site </app/schema/catalogue.js