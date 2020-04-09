#! /bin/bash
#sudo check
if ! [ $(id -u) = 0 ]; then echo "Please run this script as sudo or root"; exit 1 ; fi

echo "Welcome! I'll install all your services and should have you up and running in no time! " 

echo "Updating Repository"
apt update

echo "Installing an RDP Viwer"
apt-get install vinagre -y
apt-get install linux-headers-gcp
apt-get install virtualbox -y

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
apt install -y apt-transport-https curl
apt install -y xfce4
apt install -y xrdp 
apt install -y openvpn 
apt install -y firefox
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
usermod -aG sudo baccc2

#Change the default rdp port number Change 3389 to 3391

sed -i 's/3389/3391/1' /etc/xrdp/xrdp.ini

#rdp blue screen issue
cd /etc/xrdp
sed -i '14 a unset DBUS_SESSION_BUS_ADDRESS' startwm.sh
sed -i '15 a unset XDG_RUNTIME_DIR' startwm.sh
sed -i '16 a . $HOME/.profile' startwm.sh

#Load up Docker and the container
mkdir /home/baccc2/iso
mkdir /home/baccc2/container/
cd /home/baccc2/container/

#Download iso from bucket
#get iso from somewhere. I'll be uploading it in this dir


#Download required files
wget https://raw.githubusercontent.com/johnfsu/ContainerizedVirus/master/Installwindowsxp.sh
wget https://raw.githubusercontent.com/johnfsu/ContainerizedVirus/master/Dockerfile


docker pull ubuntu:latest
docker stop winxp3
docker rm winxp3
docker build --tag winxp3 .

docker run --rm -it --privileged=true -p 3389:3389 --name winxp3 winxp3:latest /bin/sh -c "./Installwindowsxp.sh"
