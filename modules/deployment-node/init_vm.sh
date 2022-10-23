#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker

sudo yum install git -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose

git clone https://github.com/richiMarchi/scratchpay-challenge.git && cd scratchpay-challenge
docker-compose up -d
