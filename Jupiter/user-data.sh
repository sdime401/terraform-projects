#!/bin/bash
sudo su
yum update -y
sudo yum install -y httpd httpd-tools mod_ssl
chkconfig httpd on
cd /var/www/html
aws s3 sync s3://s3web.myaws2022lab.com /var/www/html
sudo systemctl enable httpd 
sudo systemctl start httpd