#!/bin/sh

MASTERNODES=$1
DATANODES=$2

rm -f /home/pivotpde/hdphosts.txt

echo "setting hostname for ambari node and restarting network..."
hostname edgenode.hawqdatalake.com
echo "10.0.0.4	edgenode.hawqdatalake.com	edgenode" >> /home/pivotpde/hdphosts.txt


echo "setting hostnames and ip for masternodes ....."
startIp=5
for (( c=0; c<$MASTERNODES; c++ ))
do
    mhost=masternode$c
    mhostfqdn=$mhost.hawqdatalake.com
    ssh 10.0.0.$startIp 'sudo su -c "hostname $mhostfqdn"'
    echo "10.0.0.$startIp       $mhostfqdn      $mhost" >> /home/pivotpde/hdphosts.txt
   ((startIp = startIp + 1))
done

echo "setting hostnames and ip for datanodes ...."
startIp=11
for (( d=0; d<$DATANODES; d++ ))
do
    dhost=datanode$d
    dhostfqdn=$dhost.hawqdatalake.com
    ssh 10.0.0.$startIp 'sudo su -c "hostname $dhostfqdn"'
    echo "10.0.0.$startIp       $dhostfqdn       $dhost"  >> /home/pivotpde/hdphosts.txt
   ((startIp = startIp + 1))
done

echo "restart network on ambari host...."
sudo su -c "cat hdphosts.txt >> /etc/hosts"
sudo su -c "service network restart"
echo "restarting ambari-server"
ambari-server restart

echo "copying hosts info to masternodes and restarting network ....... "
startIp=5

for (( e=0; e<$MASTERNODES; e++ ))
do
   sudo su -c "scp /etc/hosts root@10.0.0.$startIp:/etc/hosts "
   ssh 10.0.0.$startIp 'sudo su -c "service network restart"'
   ssh 10.0.0.$startIp 'sudo su -c "setenforce 0"'
   ((startIp = startIp + 1))
done

echo "copying hosts info to datanodes and restarting network....... "
startIp=11
for (( f=0; f<$DATANODES; f++ ))
do
   sudo su -c "scp /etc/hosts root@10.0.0.$startIp:/etc/hosts "
   ssh 10.0.0.$startIp 'sudo su -c "service network restart"'
   ssh 10.0.0.$startIp 'sudo su -c "setenforce 0"'
   ((startIp = startIp + 1))
done

echo "start ambari agent on master nodes...."
startIp=5
for (( g=0; g<$MASTERNODES; g++ ))
do
   echo "start ambari agent on host 10.0.0.$startIp ......"
   ssh root@10.0.0.$startIp ambari-agent restart
   echo " finished executing script on host 10.0.0.$startIp."
   ((startIp = startIp + 1))
done

echo "start ambari agent on data nodes...."
startIp=11
for (( h=0; h<$DATANODES; h++ ))
do
    echo "start ambari agent on host 10.0.0.$startIp ......"
    ssh root@10.0.0.$startIp ambari-agent restart
    echo " finished executing script on host 10.0.0.$startIp."
	((startIp = startIp + 1))
done
