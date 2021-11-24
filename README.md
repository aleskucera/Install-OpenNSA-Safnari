# Installation of Opennsa and Safnari
To install Opennsa, nsi-safnari, nsi-dds and nsi-pce we will follow these steps:
* Install software prerequisites
* Download the source
* Setup ansible
* Update variable files
* Secure sensitive data
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
### Passwords
The most secure way to set up passwords is through `secure_config.sh`. More about this is in section [Secure sensitive data](#secure-sensitive-data).
### Config variables

## Secure sensitive data
For security reasons it's recommended to configure and encrypt sensitive data with `secure_config.sh`. 

In first part you will be asked to enter **ansible_become_pass** which is password for Ansible user to use `sudo` privileges, **user_password** is password for app specific user which script makes and **postgres_user_pass** is password for Postgre SQL user.

In the second part you can encrypt your password file and private key with Ansible Vault. You can always decrypt these files by

    ansible-vault decrypt ./opennsa/vars/passwords.yml ./opennsa/ssl/private_key.pem

By default you have to remember Ansible Vault password, but you can use more advanced features described here: https://docs.ansible.com/ansible/latest/user_guide/vault.html.

## Run Ansible playbook
After everything is ready you can run ansible script by

    ansible-playbook opennsa/playbook.yml

if you encrypted passwords or certificate with Ansible Vault you have to add an argument `--ask-vault-pass`.

    ansible-playbook opennsa/playbook,yml --ask-vault-pass

It is critical, that you run this command in the same folder where is `ansible.cfg` and `hosts` file stored.


