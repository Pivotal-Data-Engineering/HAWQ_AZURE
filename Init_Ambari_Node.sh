#!/bin/sh
sudo su -c "sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers"
sudo su -c "echo 0 > /selinux/enforce"
sudo su -c "sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux"
sudo su -c "service iptables stop"
sudo su -c "chkconfig iptables off"
sudo su -c "chkconfig ip6tables off"
sudo su -c "wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -P /etc/yum.repos.d/"
sudo su -c "yum install -y ambari-server"
sudo su -c "ambari-server setup -s"
sudo su -c "ambari-server start"
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"

#mkdir -p /home/$ADMINUSER/.ssh
sudo yoda -c "ssh-keygen -f /home/yoda/.ssh/id_rsa -t rsa -N '' "
sudo yoda -c "chmod 700 /home/yoda/.ssh"
sudo yoda -c "chmod 600 /home/yoda/.ssh/authorized_keys"
