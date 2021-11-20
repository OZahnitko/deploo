#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker pull ozahnitko/deploo:latest
sudo docker run -d -p 80:3000 ozahnitko/deploo:latest 
