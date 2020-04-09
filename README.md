# Containerized Virus
Docker Container Running Vbox Inside of a GCP VM

Google Cloud Platform hosts an Ubuntu 18.04 virtual machine with settings to allow Nested Virtualiztion. Inside of the virtual machine Docker is installed to be able to contain the virus. Inside of Docker VirtualBox is installed and inside of VirtualBox Windows Xp is installed. 

This architecture was designed to be able to contain the deployment of a virus in a cloud environment to prevent the spread of it. The virus is being deployed for educational purposes and is not intended to be an attack on any system. Students are to deploy the virus and then simulate how one would recover from it using one of the many tools available. 



# Set up a Virtual Machine with Nested Virtualization enabled on GCP

Open up Google Cloud Shell and type in the following commands. I will be using an Ubuntu 18.04 OS. 

#Creates a Boot Disk for the image
gcloud compute disks create disk2 --image-project ubuntu-os-cloud --image-family ubuntu-1804-lts --zone us-central1-b

#Creates a custom image with the above boot disk to add on the liscensing

gcloud compute images create nested-vm --source-disk disk2 --source-disk-zone us-central1-b --licenses "https://compute.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
  
#Creates an instance named nested-vm

gcloud compute instances create nested-vm --zone us-central1-b --min-cpu-platform "Intel Haswell" --image nested-vm
 
 #note that the Ram will need to be changed to 7.5 Gb in order to handle to VMs
 
 
 # Install Docker
 After getting the VM install Docker with the script
 Dockerinstall.sh
 
 
 # Install RDP 
 Will be using Banzana's RDP install script
 
 After installing, change the default rdp port 3389 to 3391 by going into /etc/xrdp/xrdp.ini
 and changinge the "tcp port listening to"
 

# Full Install
For a full install, simply run the FullInstall script and everything will be done for you. 

 
