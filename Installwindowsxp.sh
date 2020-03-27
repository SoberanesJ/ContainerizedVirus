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
