echo "--------------------------------------"


echo "Updating Repository"
sudo apt update

#Dependencies
echo "Getting Dependicies" 
sudo apt install apt-transport-https ca-certificates curl software-properties-common

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
sudo apt install docker-ce


#CHECK IF IT IS RUNNING
echo "Checking to See if the system is running..."

sudo systemctl status docker


echo "You are all set!" 
