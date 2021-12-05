#!/bin/bash

hosts_dir=./hosts/production/
secrets_file=secrets.yml
private_key=files/private_key.pem

echo "This script will configure and secure sensitive data using mkpasspwd and Ansible vault."
echo "If you do not have mkpasswd installed on your computer, please install it by"
echo
echo "     apt install whois"
echo
read -r -p "WARNING: This action will overwrite $hosts_dir$secrets_file, are you sure you want to continue? [Y/n]" permission

case $permission in 
    [yY][eE][sS]|[yY])

    echo "Enter ansible user sudo password: " 
    read -s ansible_become_pass

    echo "Enter app specific user password: "
    read -s user_password
    user_password_hashed="$(echo "$user_password" | mkpasswd -m sha-512 /dev/stdin)"

    echo "Enter Postgre SQL user password password: "
    read -s postgres_user_pass
    postgres_user_pass_hashed="$(echo "$postgres_user_pass" | mkpasswd -m sha-512 /dev/stdin)"

    echo "Saving changes to $hosts_dir$secrets_file..."
    echo "---" > $hosts_dir$secrets_file
    echo "ansible_become_pass: '$ansible_become_pass'" >> $hosts_dir$secrets_file
    echo "user_password: '$user_password'" >> $hosts_dir$secrets_file
    echo "user_password_hashed: '$user_password_hashed'" >> $hosts_dir$secrets_file
    echo "postgres_user_pass: '$postgres_user_pass'" >> $hosts_dir$secrets_file
    echo "postgres_user_pass_hashed: '$postgres_user_pass_hashed'" >> $hosts_dir$secrets_file
    ;;
*)
esac

read -p "Do you want to encrypt passwords and private key? [Y/n]" permission
case $permission in 
    [yY][eE][sS]|[yY])
    echo "Please enter password for Ansible vault"
    ansible-vault encrypt $hosts_dir$secrets_file $hosts_dir$private_key
    ;;
*)
esac

echo "Your sensitive data were encrypted. You can always decrypt your data with command"
echo
echo "  ansible-vault decrypt $hosts_dir$secrets_file $hosts_dir$private_key"
echo