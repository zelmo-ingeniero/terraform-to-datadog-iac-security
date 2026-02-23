#!/bin/bash
# al2023
sudo su -
dnf -y update
dnf -y install docker
useradd -g docker docker
systemctl enable --now docker
systemctl start docker
exit
# once logged in run the next with mservices or ec2-user
# usermod -aG docker $USER
