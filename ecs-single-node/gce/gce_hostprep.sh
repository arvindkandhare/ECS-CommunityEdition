#!/usr/bin/env bash
#Created by Kendrick Coleman of the EMC {code} Team and Licensed under MIT.
#Please visit us at emccode.github.io
#This script will prepare an Ubuntu Host for running an ECS container. 
#This has been properly tested with Docker Machine's default image in AWS.

set -v

#Read in variable arguments from command line
#if [ -z "$1" ]; then
#  echo "You forgot to specify 3 IP Addresses"
#  exit 1
#fi

#case "$1" in  
#     *\ * )
#           echo "Please remove all spaces and have IP addresses as comma seperated values"
#  		   exit 1
#          ;;
#esac

#VOL="$2"
#if [ -z "$2" ]; then
#  VOL="xvdf"
#  echo "Using xvdf as Volume mount"
#fi

#Add storageos group

addgroup  storageos --gid=444
adduser storageos --uid=444 --gid=444 --quiet --system

#update system and install xfs
echo "Updating Debian/Ubuntu"
apt-get update -y
echo "Install XFS Tools"
apt-get install xfsprogs -y
echo "Installing dbus tools"
apt-get install dbus -y
apt-get install python-dbus -y
apt-get install python-gobject -y
apt-get install docker.io -y
service docker start


#ip=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')


cp com.emc.vipr.fabric.hal.conf /etc/dbus-1/system.d

echo "Starting the dbus server"
nohup python dbus_service.py < /dev/null >/dev/null 2>&1 &

echo "Install nsenter"
apt-get install nsenter -y

#create the seeds file
#echo "Creating Seeds File"
#printf '%s' $1 > seeds

#create network.json file
#echo "Creating The network.json File"
#hn=$(hostname)
#ip=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
#printf '{"private_interface_name":"eth0","public_interface_name":"eth0","hostname":"%s","public_ip":"%s"}' $hn $ip > network.json

