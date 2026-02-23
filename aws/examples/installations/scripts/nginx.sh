#!/bin/bash
TODAY=$(date "+%d_%m_%Y")
NGINX_VERSION=nginx-1.25.0
yum install -y make gcc-c++ python3 python3-pip
sudo su -
cd /opt
groupadd nginx
useradd nginx
wget https://nginx.org/download/$NGINX_VERSION.tar.gz
tar fhxz $NGINX_VERSION.tar.gz
cd $NGINX_VERSION
./configure --without-http_rewrite_module --without-http_gzip_module
make install
cp /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx_$TODAY.conf
#
# add more configuration here
#
sed -i '36 s/80/443/' /usr/local/nginx/conf/nginx.conf
cd /usr/local/nginx/sbin/
rm -rf /$NGINX_VERSION $NGINX_VERSION.tar.gz
./nginx
