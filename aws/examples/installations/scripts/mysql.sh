#!/bin/bash
MYSQL_VERSION="8.1.0-1"
sudo su -
cd /

# == MySQL ==
wget https://dev.mysql.com/get/Downloads/MySQL-8.1/mysql-community-common-$MYSQL_VERSION8.el9.x86_64.rpm
wget https://dev.mysql.com/get/Downloads/MySQL-8.1/mysql-community-client-plugins-$MYSQL_VERSION8.el9.x86_64.rpm
wget https://dev.mysql.com/get/Downloads/MySQL-8.1/mysql-community-libs-$MYSQL_VERSION8.el9.x86_64.rpm
wget https://dev.mysql.com/get/Downloads/MySQL-8.1/mysql-community-client-$MYSQL_VERSION8.el9.x86_64.rpm
wget https://dev.mysql.com/get/Downloads/MySQL-8.1/mysql-community-icu-data-files-$MYSQL_VERSION8.el9.x86_64.rpm
wget https://dev.mysql.com/get/Downloads/MySQL-8.1/mysql-community-server-$MYSQL_VERSION8.el9.x86_64.rpm
rpm -Uh mysql-community-common-$MYSQL_VERSION8.el9.x86_64.rpm
rpm -Uh mysql-community-client-plugins-$MYSQL_VERSION8.el9.x86_64.rpm
rpm -Uh mysql-community-libs-$MYSQL_VERSION8.el9.x86_64.rpm
rpm -Uh mysql-community-client-$MYSQL_VERSION8.el9.x86_64.rpm
rpm -Uh mysql-community-icu-data-files-$MYSQL_VERSION8.el9.x86_64.rpm
rpm -Uh mysql-community-server-$MYSQL_VERSION8.el9.x86_64.rpm
rm -rf mysql-community-*
#
# configuration here
#
systemctl start mysqld
