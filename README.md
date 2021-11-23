# Description
This script is written for deployment of OpenNSA and Safnari on Ubuntu 20.04 and consists of three main parts - templates, variables and playbook. **Templates** directory contains all important configuration templates and **should be changed only if necessary**. The **vars**  directory is the only directory, that is meant for making changes. General variables are stored in `vars\general.yml` file and changing this file is not needed. However the `vars\passwords.yml` must be changed and it is recommended to secure this file properly as described later in the text. The last file `vars\config.yml` stores all the variables, that are used in configuration templates.

**Playbook.yml** file is ansible script, that consists of these steps:
* Sets up prerequisites for OpenNSA
* Creates app specific user
* Downloads OpenNSA repository
* Sets up virtual environment for OpenNSA
* Configures OpenNSA
* Creates PostgreSQL user and database
# Installation of Opennsa and Safnari
To install Opennsa, nsi-safnari, nsi-dds and nsi-pce we will follow these steps:
* Install software prerequisites
* Download the source
* Setup ansible
* Update variable files
* Encrypt passwords for better security
* Run ansible playbook
## Install software prerequisites
The script is written in **Ansible**. To install Ansible on Ubuntu run:

    sudo apt update
    sudo apt install ansible 

Next, we need to install additional community modules, that script uses

    ansible-galaxy collection install community.postgresql
    ansible-galaxy collection install community.general

## Download the source
After we download prerequisites we go to the directory, where we want to store the script and download the git repository by

    git clone https://gitlab.cesnet.cz/hazlinsky/crp-ansible-test.git
    
## Ansible setup
Ansible uses ssh for connection to host devices. For successful launch of the script we presume following:

* There is **one sudo user** on target devices with **matching name and password**
* Connection between main host and other hosts is possible via ssh with **ssh key**

To specify on which devices should be software installed open `hosts` file. Then change default IP address to IP address of target devices, and ansible user to sudo user where ssh connection is set up. If we would have 3 target hosts wit IP addresses `192.168.56.100, 192.168.56.101, 192.168.56.102` and user would we `user` then `hosts` file should look like this:

    [servers]
    192.168.56.100
    192.168.56.101
    192.168.56.102

    [servers:vars]
    ansible_python_interpreter=/usr/bin/python3
    ansible_user=user 

The `[servers]` specifies group of servers. You can create another group for example `[test_servers]` with IP's and variables below. If you would like to run ansible playbook on those servers, you have to change `hosts: ` variable in `opennsa\playbook.yml`. So now header of `opennsa\playbook.yml` should look like that

    --- 
        - hosts: test_servers
            become: true
            vars_files:
            - vars/general.yml
            - vars/passwords.yml
            - vars/config.yml

## Update variable files
### General variables
General varibles are stored in `opennsa\vars\general.yml` and changing them is not recommended.
### Config variables

### Passwords
All passwords are stored in `opennsa/vars/password.yml` file. `ansible_become_pass` is password for Ansible user to use `sudo` privileges, `user_password` is password for app specific user which script makes and `postgres_user_pass` is password for Postgre SQL user.
    
## Encrypting passwords
For installation the script uses sensible data such as sudo password, app user password and PostgreSQL user password stored in `vars/passwords.yml` In order to secure this kind of data Ansible uses Ansible-vault. But before we secure our data we should change default passwords in `vars/passwords.yml`. Then we encrypt this file by command 

    ansible-vault encrypt vars/passwords.yml

Ansible asks us for vault password, which we will have to use everytime we want to access our passwords. If we ever want to change the password we can do that by 

    ansible-vault rekey vars/passwords.yml

The most secure way is to remember this password, but if we are not sure of it, we can store this password to the file and automate the process of authentication to ansible-vault. Just change `"vault-password"` to your password and save it to desired path in your computer.

    echo "vault-password" > vars/password_file

## Run Ansible playbook
After everything is ready you can run ansible script by

    ansible-playbook opennsa/playbook.yml

if you encrypted passwords or certificate with ansible vault you have to add an argument `--ask-vault-pass`.

    ansible-playbook opennsa/playbook,yml --ask-vault-pass

It is critical, that you run this command in the same folder where is `ansible.cfg` and `hosts` file stored.


