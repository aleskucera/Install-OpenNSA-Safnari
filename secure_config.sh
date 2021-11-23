#!/bin/bash

password_file=./opennsa/vars/passwords.yml
private_key=./opennsa/ssl/private_key.pem

echo "$password_file"
echo "This script will configure and secure sensitive data using mkpasspwd and Ansible."
echo "If you do not have mkpasswd installed on your computer, please install it by"
echo
echo "     apt install whois"
echo
read -p "WARNING: This action will overwrite $password_file, are you sure you want to continue? [Y/n]" permission

if [[ "$permission" == y ]] || [[ "$permission" == Y ]]
then

    echo "Enter ansible user sudo password: " 
    read -s ansible_become_pass

    echo "Enter app specific user password: "
    read -s user_password
    user_password_hashed="$(echo "$user_password" | mkpasswd -m sha-512 /dev/stdin)"

    echo "Enter Postgre SQL user password password: "
    read -s postgres_user_pass
    postgres_user_pass_hashed="$(echo "$postgres_user_pass" | mkpasswd -m sha-512 /dev/stdin)"

    echo "Saving changes to $password_file..."
    echo "---" > $password_file
    echo "ansible_become_pass: '$ansible_become_pass'" >> $password_file
    echo "user_password: '$user_password'" >> $password_file
    echo "user_password_hashed: '$user_password_hashed'" >> $password_file
    echo "postgres_user_pass: '$postgres_user_pass'" >> $password_file
    echo "postgres_user_pass_hashed: '$postgres_user_pass_hashed'" >> $password_file
fi

read -p "Do you want to encrypt passwords and private key? [Y/n]" permission
if [[ "$permission" == y ]] || [[ "$permission" == Y ]]
then
echo "Please enter password for Ansible vault"
ansible-vault encrypt $password_file $private_key
fi

echo "Your sensitive data were encrypted. You can always decrypt your data with command"
echo
echo "  ansible-vault decrypt $password_file $private_key"
echo