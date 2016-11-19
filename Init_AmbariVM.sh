#!/bin/sh
ADMINUSER=$1
HDB_VERSION=$2
sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
echo "$ADMINUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "disable selinux"
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

service iptables stop
chkconfig iptables off
chkconfig ip6tables off


#sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"

yum install -y ntp
chkconfig ntpd on
service ntpd start

echo 'umask 0022' >> /etc/profile

#Disable  Transparent Huge Pages 
echo "if test -f /sys/kernel/mm/transparent_hugepage/enabled; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled fi if test -f /sys/kernel/mm/transparent_hugepage/defrag; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag fi" >> /etc/rc.local
echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/defrag

echo "Downloading Ambari repo....."
wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -P /etc/yum.repos.d/
echo "installing ambari server ...."
yum install -y ambari-server
echo "running ambari setup with defaults....."
ambari-server setup -s
echo "starting Ambari ...."
ambari-server start

#echo"changing ambari server port to 8090..."
#echo "client.api.port=8090" >> /etc/ambari-server/conf/ambari.properties
#ambari-server restart

echo "setting nohost check for ssh ..."
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
service sshd restart

echo "install httpd ........."
yum -y install httpd
echo "starting httpd..."
service httpd start
echo "preparing folders for hawq install ...."
mkdir /staging
chmod a+rx /staging
echo "downloading hawq software ...."
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token y7BWf35sarZ6g46GpeLM" -X GET https://network.pivotal.io/api/v2/authentication
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token y7BWf35sarZ6g46GpeLM" -X GET https://network.pivotal.io/api/v2/products/pivotal-hdb/releases/2397/eula_acceptance
wget -O "Pivotal_HDB.tar.gz" -P "/staging" --post-data="" --header="Authorization: Token y7BWf35sarZ6g46GpeLM" https://network.pivotal.io/api/v2/products/pivotal-hdb/releases/2397/product_files/7634/download
echo "extracting hawq download ...."
tar -zxvf Pivotal_HDB.tar.gz -C /staging
echo "setting local hawq repo ...."
/staging/hdb-*/setup_repo.sh
echo "restart ambari server...."
ambari-server restart

echo "Installing hawq-ambari-plugin ...."
yum install -y hawq-ambari-plugin
/var/lib/hawq/add-hawq.py --user admin --password admin --stack HDP-2.4
ambari-server restart

echo "install hawq plugin..."
yum install -y hawq-ambari-plugin
/var/lib/hawq/add-hawq.py --user admin --password admin --stack HDP-2.4
ambari-server restart

echo "Finished executing the initAmbariVM."











