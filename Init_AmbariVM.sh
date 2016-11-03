#!/bin/sh
ADMINUSER=$1

sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
echo "$ADMINUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "disable selinux"
set enforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

service iptables stop
chkconfig iptables off
chkconfig ip6tables off
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"

yum install -y ntp
chkconfig ntpd on
service ntpd start

echo 'umask 0022' >> /etc/profile

echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
service sshd restart

echo " Installing Ambari....."
wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -P /etc/yum.repos.d/
yum install -y ambari-server
ambari-server setup -s



echo "downloading hawq software ...."
mkdir /staging
chmod a+rx /staging

curl -i -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token y7BWf35sarZ6g46GpeLM" -X GET https://network.pivotal.io/api/v2/authentication
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token y7BWf35sarZ6g46GpeLM" -X GET https://network.pivotal.io/api/v2/products/pivotal-hdb/releases/2397/eula_acceptance
wget -O "Pivotal_HDB.tar.gz" -P "/staging" --post-data="" --header="Authorization: Token y7BWf35sarZ6g46GpeLM" https://network.pivotal.io/api/v2/products/pivotal-hdb/releases/2397/product_files/7634/download

echo "extracting hawq download ...."
tar -zxvf Pivotal_HDB.tar.gz -C /staging


echo "install httpd ........."
yum -y install httpd
service httpd start

echo "adding repo ...."
sh /staging/Pivotal_HDB/setup_repo.sh

service httpd stop

echo "starting Ambari ...."
ambari-server start

echo "Finished executing the initAmbariVM."










