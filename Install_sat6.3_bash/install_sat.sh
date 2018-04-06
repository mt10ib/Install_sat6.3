#!/bin/bash

subscription-manager register --username <username> --password <password>

Pool_ID=$(subscription-manager list --available --matches "Red Hat Satellite" | grep 'Pool ID' | awk 'FNR == 1 {print$3}')

subscription-manager attach --pool $Pool_ID

subscription-manager repos --disable "*"

subscription-manager repos --enable rhel-7-server-rpms --enable rhel-server-rhscl-7-rpms --enable rhel-7-server-satellite-6.3-rpms

# Install satellite installer
yum clean all

yum -y update

yum -y install satellite  

# copy local satellite-answers.yml, overwrite it
#cp /home/mthavarajah/Desktop/Arctiq/Projects/Install_sat6/satellite-answers.yaml /etc/foreman-installer/scenarios.d/
sed -i 's/Default Organization/Arctiq/g' /etc/foreman-installer/scenarios.d/satellite-answers.yaml 
sed -i 's/Default Location/Toronto/g' /etc/foreman-installer/scenarios.d/satellite-answers.yaml 

# Satellite installer to install Satellite
satellite-installer -v --scenario satellite --foreman-admin-username "admin" --foreman-admin-password "admin"

# Disable firewall
systemctl stop firewalld.service && systemctl disable firewalld.service






