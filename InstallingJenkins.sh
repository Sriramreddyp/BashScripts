#!/usr/bin/bash
errorlog=~/var/log/docker_error.log

#Function to rectify and stop when error occurs
check_exit_status(){
 if [ $? -ne 0 ]
 then
  echo "Error occurred in the installing process, check $errorlog for more details"
  exit 1; 
fi
}

#checking whether Jenkins exists or not
if command -v jenkins &> /dev/null
then
 echo "Jenkins exists in this system $(which jenkins)"
 exit 0
fi

echo "Updatin Packages..."

#Updating Packages
sudo apt update 2> $errorlog
check_exit_status

#checking whether Java exists or not
if command -v java &> /dev/null
then
 echo "Java exists in this system $(which java)"
else
 #Installing Java
 sudo apt install -y openjdk-11-jre
 check_exit_status
fi

#Installation Check check
which java
if [ $? -eq 0 ]
then
 echo "Java Sucessfully Installed"
else
 echo "Unexpected error occured, please reinitiate the process"
 exit 1
fi

echo "Installing Jenkins...."

#Updating Keys
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/nul

#Updating repository list
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

#Updating repository
sudo apt-get update 2> $errorlog
check_exit_status

#installing jenkins
sudo apt-get install -y jenkins 2> $errorlog
check_exit_status

#Installtion  check
which jenkins
if [ $? -eq 0 ]
then
 echo "jenkins Sucessfully Installed"
else
 echo "Unexpected error occured, please reinitiate the process"
fi
