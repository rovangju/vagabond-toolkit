#!/bin/bash

sudo yum install iptables-services -y
sudo iptables-save > /etc/sysconfig/iptables-config
sudo systemctl stop firewalld && sudo systemctl start iptables
sudo firewall-cmd --state
sudo systemctl disable firewalld
sudo systemctl mask firewalld
sudo systemctl enable iptables

sudo cat /etc/sysconfig/iptables
