#!/bin/bash
yum update -y

amazon-linux-extras install php7.4 -y
yum -y install mysql httpd php-mbstring php-xml


#EFSマウント設定
yum install -y amazon-efs-utils
efs_id="${efs_id}"
mount -t efs -o tls $efs_id:/ /var/www/html/

wget http://ja.wordpress.org/latest-ja.tar.gz -P /tmp/
tar zxvf /tmp/latest-ja.tar.gz -C /tmp
cp -r /tmp/wordpress/* /var/www/html/
chown apache:apache -R /var/www/html

systemctl enable httpd
systemctl start httpd.service