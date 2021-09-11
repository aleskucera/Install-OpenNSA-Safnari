# Installation of Opennsa and Safnari
To install Opennsa, nsi-safnari, nsi-dds and nsi-pce we will follow these steps:
* Install software prerequisites
* Downloading the source
* Setup ansible
* Update variable files
* Update configuration files
* Run ansible playbook
* Encrypt passwords for better security
## Install software prerequisites
The script is written in **Ansible**. To install Ansible on Ubuntu run:

    sudo apt update
    sudo apt install ansible 
    
## Downloading the source
After we download prerequisites we go to the directory, where we want to store the script and download the git repository by

    git clone https://github.com/Banana-Pi/Install-OpenNSA-Safnari.git
    
## Ansible setup
Ansible uses ssh for connection to host devices. For successful launch of the script we presume following:

* There is **one sudo user** on target devices with **matching name and password**
* Connection between main host and other hosts is possible via ssh with **ssh key**

To specify on which devices should be software installed open `hosts` file. Then change default IP address to IP address of target devices, and ansible user to sudo user where ssh connection is set up. If we would have 3 target hosts wit Ip addresses `192.168.56.100, 192.168.56.101, 192.168.56.102` and user would we `user` then `hosts` file should look like this:

    [servers]
    192.168.56.100
    192.168.56.101
    192.168.56.102

    [servers:vars]
    ansible_python_interpreter=/usr/bin/python3
    ansible_user=user 
    
## Encrypting passwords
By deafault password are stored as plain text, which is not safe. 

