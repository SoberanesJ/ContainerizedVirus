#####This is all done inside of the container####
#Update and Upgrade the Ubuntu System and Repositories
apt update 
apt install virtualbox -y 
apt install virtualbox-dkms -y
apt install linux-headers-gcp -y
apt install linux-headers-generic -y 

cd /home/baccc2/container/

#Import VM 
VBoxManage import winxp_1.ova

#Set Password
VBoxManage modifyvm winxp_1 --vrdeproperty VNCPassword=secret

#Start Windows XP
VBoxHeadless -v on -startvm winxp_1
