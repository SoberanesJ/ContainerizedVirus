#! /bin/bash
#sudo check
if ! [ $(id -u) = 0 ]; then echo "Please run this script as sudo or root"; exit 1 ; fi

echo "Welcome! I'll install all your services and should have you up and running in no time! " 

echo "Updating Repository"
apt update

echo "Installing an RDP Viwer"
apt-get install vinagre -y


echo "Installing Docker!" 
echo "--------------------------------------"

#Dependencies
echo "Getting Dependicies" 
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

#Add GPG Key for Docker Repository

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Add Docker Repository to APT Sources
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

#Update Repositories again
echo "Updating Repositories" 
sudo apt update
apt-cache policy docker-ce > docker-ce.log


#INSTALL DOCKER
echo "Installing Docker"
sudo apt install docker-ce -y


#CHECK IF IT IS RUNNING
echo "Checking to See if the system is running..."

sudo systemctl status docker


echo "You are all set!" 



echo "Installing XRDP ! " 

useramount=2
# accounts inc up, passwords down
username="baccc"
password="baccc"
LOG="/tmp/rdp_build.log"

#Upgrade?
echo "Upgrading...(skip)"
#apt-get -y dist-upgrade &>> ${LOG}

#installs
echo "Installs(1/2)..."
apt-get install -y apt-transport-https curl xfce4 xrdp openvpn firefox \
build-essential gdb python3 python3-pip docker.io zip \
unzip openjdk-11-jre icoutils &>> ${LOG}

echo "Installs(2/2)..."
apt-get -qq install -y wireshark 

echo "Creating Users..."
counter=1
secondcounter=$useramount
while  [ $counter -le $useramount ]
do
        useradd -s /bin/bash -m ${username}${counter}
        usermod -aG ${username}${counter} ${username}${counter}
        echo ${username}${counter}:${password}${secondcounter} | chpasswd
        ((counter++))
        ((secondcounter--))
        echo "User ${username}${counter}:${password}${secondcounter} created!" &>> ${LOG}
done

#enable RDP
sed -i '7i\echo xfce4-session >~/.xsession\' /etc/xrdp/startwm.sh
service xrdp restart
echo "Done..." 

#Make the primary account sudo to install the container
useradd -aG sudo baccc2

#Change the default rdp port number Change 3389 to 3391

sed -i 's/3389/3391/1' /etc/xrdp/xrdp.ini



#Load up Docker and the container
mkdir iso
apt-get install linux-headers-gcp

#Download iso from bucket
gsutil cp gs://nestedvm/Xphomesp3.iso /home/baccc2/iso/


cd /home/baccc2/iso/
docker pull ubuntu:latest
docker ps

docker run --rm -it --privileged=true --device /dev/vboxdrv:/dev/vboxdrv -p 3389:3389 --name winxp32 ubuntu:latest /bin/sh
exit
#Copy over iso to container
CID=$(sudo docker ps > dockerid.txt &&  tail -1 dockerid.txt  |awk '{print $1;}')
docker cp Xphomesp3.iso $CID:/

docker run --rm -it --privileged=true --device /dev/vboxdrv:/dev/vboxdrv -p 3389:3389 --name winxp32 ubuntu:latest /bin/sh

#####This is all done inside of the container####
#Update and Upgrade the Ubuntu System and Repositories
sudo su
apt update && upgrade
apt install sudo
apt install vim -y
apt install virtualbox -y 

#This file is installed inside of the Ubuntu 16.04 container
mkdir -p /vbox/vdisks
mkdir -p /vbox/iso
cd /
mv Xphomesp3.iso vbox/iso/

VBoxManage createvm --name winxp32 --register --basefolder /vbox/vms/


VBoxManage createhd --filename /vbox/vdisks/winxp32.vdi --size 10240 --variant Standard


VBoxManage storagectl winxp32 --name "IDE Controller" --add ide --controller PIIX4 --bootable on

#Replace the iso file with your preferred iso
VBoxManage storageattach winxp32 --storagectl "IDE Controller" --type dvddrive --port 1 --device 0 --medium /vbox/iso/Xphomesp3.iso



VBoxManage storageattach winxp32 --storagectl "IDE Controller" --type hdd --port 0 --device 0 --medium /vbox/vdisks/winxp32.vdi


VBoxManage modifyvm winxp32 --dvd /vbox/iso/Xphomesp3.iso


VBoxManage modifyvm winxp32 --boot1 dvd

VBoxManage modifyvm winxp32 --boot2 disk

VBoxManage modifyvm winxp32 --memory 1024

VBoxManage modifyvm winxp32 --nic1 nat

VBoxManage modifyvm winxp32 --cableconnected1 on

VBoxManage modifyvm winxp32 --nicpromisc1 allow-all

VBoxManage modifyvm winxp32 --natpf1 "smb139,tcp,,139,10.0.2.15,139"

VBoxManage modifyvm winxp32 --natpf1 "smb445,tcp,,445,10.0.2.15,445"

VBoxManage modifyvm winxp32 --natpf1 "lport4444,tcp,,4444,10.0.2.15,4444"
#Set Password
VBoxManage modifyvm winxp32 --vrdeproperty VNCPassword=secret

#Start Windows XP
VBoxHeadless -v on -startvm winxp32

