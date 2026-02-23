#!/bin/bash
sudo su -
cd /etc/yum.repos.d
echo "[mongodb-org-7.0]" > mongodb-org-7.0.repo
sed -i '1 a name=MongoDB Repository' mongodb-org-7.0.repo
sed -i '2 a baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/' mongodb-org-7.0.repo
sed -i '3 a gpgcheck=1' mongodb-org-7.0.repo
sed -i '4 a enabled=1' mongodb-org-7.0.repo
sed -i '5 a gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc' mongodb-org-7.0.repo
yum install -y mongodb-org-7.0.3 mongodb-org-database-7.0.3 mongodb-org-server-7.0.3 mongodb-org-tools-7.0.3
dnf erase -y mongodb-mongosh
dnf install -y mongodb-mongosh-shared-openssl3
# expecting that /etc/yum.conf not exists
echo "exclude=mongodb-org,mongodb-org-database,mongodb-org-server,mongodb-mongosh,mongodb-org-mongos,mongodb-org-tools" > /etc/yum.conf
systemctl enable mongod
systemctl start mongod
