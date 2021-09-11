# Installation of Opennsa and Safnari
To install Opennsa, nsi-safnari, nsi-dds and nsi-pce we will follow these steps:
* Install software prerequisites
* Downloading the source
* Setup ansible
* Update variable files
* Update configuration files
* Encrypt passwords for better security
* Run ansible playbook
## Install software prerequisites
The script is written in **Ansible**. To install Ansible on Ubuntu run:

    sudo apt update
    sudo apt install ansible 

## Downloading the source
After we download prerequisites we go to the directory, where we want to store the script and download the git repository by

    git clone https://github.com/Banana-Pi/Install-OpenNSA-Safnari.git
    


