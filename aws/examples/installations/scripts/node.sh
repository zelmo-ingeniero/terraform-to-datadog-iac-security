#!/bin/bash
NODE_VERSION=node-v20.11.1-linux-x64
sudo su -
cd /opt
wget https://nodejs.org/dist/v20.11.1/$NODE_VERSION.tar.gz
tar fhx $NODE_VERSION.tar.gz
mv $NODE_VERSION nodejs
ln -s /opt/nodejs/bin/node /usr/bin/node
ln -s /opt/nodejs/bin/npm /usr/bin/npm
rm -rf $NODE_VERSION.tar.gz
exit