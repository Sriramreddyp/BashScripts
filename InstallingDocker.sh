#!/usr/bin/bash
#checking whether docker exists or not

errorlog=~/var/log/docker_error.log

if command -v docker &> /dev/null
then
 echo "Docker exists in this system $(which docker)"
 exit 0
fi

#Function to rectify and stop when error occurs
check_exit_status(){
 if [ $? -ne 0 ]
 then
  echo "Error occurred in the installing process, check $errorlog for more details"
  exit 1; 
fi
}

#Initial setup before installing docker
sudo apt-get update 2>> $errorlog
check_exit_status

sudo apt-get install ca-certificates curl gnupg 2> $errorlog
check_exit_status

sudo install -m 0755 -d /etc/apt/keyrings 2> $errorlog
check_exit_status

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 2> $errorlog
check_exit_status

sudo chmod a+r /etc/apt/keyrings/docker.gpg 2> $errorlog
check_exit_status

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update 2> $errorlog
check_exit_status

#installing docker
sudo apt-get install -y docker.io 2> $errorlog
check_exit_status

#final check
which docker
if [ $? -eq 0 ]
then
 echo "Docker Sucessfully Installed"
else
 echo "Unexpected error occured, please reinitiate the process"
fi
