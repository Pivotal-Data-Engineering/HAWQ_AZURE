#!/bin/sh
userName=$1
sudo su -c "sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers"
sudo su -c "echo 0 > /selinux/enforce"
sudo su -c "sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux"
sudo su -c "service iptables stop"
sudo su -c "chkconfig iptables off"
sudo su -c "chkconfig ip6tables off"
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"

sudo su -c 'echo "${userName}    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
sudo su -c "su - ${userName} -c 'ssh-keygen -f /home/${userName}/.ssh/id_rsa1 -t rsa -N "'""'"'"
sudo su -c "su - ${userName} -c 'chmod 700 /home/${userName}/.ssh' "
sudo su -c "su - ${userName} -c 'chmod 600 /home/${userName}/.ssh/authorized_keys' "
sudo su -c "yum install -y expect"

sudo su -c "wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -P /etc/yum.repos.d/"
sudo su -c "yum install -y ambari-server"
sudo su -c "ambari-server setup -s"
sudo su -c "ambari-server start"

