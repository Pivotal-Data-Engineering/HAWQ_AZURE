#!/bin/sh

MASTERNODES=$1
DATANODES=$2
AMB_VERSION=$3

startIp=5
for (( c=0; c<$MASTERNODES; c++ ))
do
    mhost=masternode$c
	echo "$mhost: Downloading Ambari repo version $AMB_VERSION ....."
	ssh $mhost "sudo su -c 'wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/$AMB_VERSION/ambari.repo -P /etc/yum.repos.d/'"
	echo "mhost: install ambari agent ....."
	ssh $mhost "sudo su -c 'yum install -y ambari-agent'"
	echo "setup the ambari server name in /etc/ambari-agent/conf/ambari-agent.ini"
	ssh $mhost sudo 'su -c " sed -i 's/hostname=localhost/hostname=edgenode.hawqdatalake.com/g' /etc/ambari-agent/conf/ambari-agent.ini " '
	echo "mhost : start ambari agent ....."
	ssh $mhost  " sudo su -c 'ambari-agent start' "
	((startIp = startIp + 1))
done;	

startIp=11
for (( d=0; d<$DATANODES; d++ ))
do
    dhost=datanode$d
	echo "$dhost: Downloading Ambari repo version $AMB_VERSION ....."
	ssh $dhost "sudo su -c 'wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/$AMB_VERSION/ambari.repo -P /etc/yum.repos.d/'"
	echo "mhost: install ambari agent ....."
	ssh $dhost "sudo su -c 'yum install -y ambari-agent'"
	echo "setup the ambari server name in /etc/ambari-agent/conf/ambari-agent.ini"
	ssh $dhost sudo 'su -c " sed -i 's/hostname=localhost/hostname=edgenode.hawqdatalake.com/g' /etc/ambari-agent/conf/ambari-agent.ini " '
	echo "dhost : start ambari agent ....."
	ssh $dhost  " sudo su -c 'ambari-agent start' "
	((startIp = startIp + 1))
done;	



