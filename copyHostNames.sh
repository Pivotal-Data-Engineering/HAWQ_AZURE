#!/bin/sh

MASTERNODES=$1
DATANODES=$2

rm -f /home/pivotpde/hdphosts.txt

#sed -i "s/.*edgenode.*/edgenode.hawqdatalake.com/g" /etc/sysconfig/network
sed -i "s/.*`hostname`*/`hostname`.hawqdatalake.com/g" /etc/sysconfig/network
hostname edgenode.hawqdatalake.com
echo '`hostname -I`	edgenode.hawqdatalake.com	edgenode'  >> /etc/hosts
service network restart

echo "getting hostnames and ip for masternodes ....."
startIp=5

for (( c=1; c<=$MASTERNODES; c++ ))
do
	sed -i "s/.*`hostname`*/`hostname`.hawqdatalake.com/g" /etc/sysconfig/network
    ssh 10.0.0.$startIp "sudo su -c hostname `hostname`.hawqdatalake.com"
    ssh 10.0.0.$startIp "sudo su -c sudo su -c service network restart"   
    echo "" >> /home/pivotpde/hdphosts.txt	
	echo "10.0.0.$startIp	masternode$d.hawqdatalake.com	masternode$d">> /home/pivotpde/hdphosts.txt
   ((startIp = startIp + 1))
done

echo "getting hostnames and ip for datanodes ...."

startIp=11
for (( d=1; d<=$DATANODES; d++ ))
do
	sed -i "s/.*`hostname`*/`hostname`.hawqdatalake.com/g" /etc/sysconfig/network
    ssh 10.0.0.$startIp "sudo su -c hostname `hostname`.hawqdatalake.com"
    ssh 10.0.0.$startIp "sudo su -c sudo su -c service network restart"   
   echo "" >> /home/pivotpde/hdphosts.txt
   echo "10.0.0.$startIp	datanode$d.hawqdatalake.com	datanode$d">> /home/pivotpde/hdphosts.txt
   ((startIp = startIp + 1))
done

sudo su -c "cat hdphosts.txt >> /etc/hosts"

echo "copying hosts info to masternodes ....... "
startIp=5

for (( e=1; e<=$MASTERNODES; e++ ))
do
   sudo su -c "scp /etc/hosts root@10.0.0.$startIp:/etc/hosts "
   ((startIp = startIp + 1))
done

echo "copying hosts info to datanodes ....... "
startIp=11
for (( f=1; f<=$DATANODES; f++ ))
do
   echo "" >> /home/pivotpde/hdphosts.txt	
   sudo su -c "scp /etc/hosts root@10.0.0.$startIp:/etc/hosts "
   ((startIp = startIp + 1))
done

echo "start ambari agent on master nodes...."
startIp=5
for (( c=1; c<=$MASTERNODES; c++ ))
do
   echo "start ambari agent on host 10.0.0.$startIp ......"
   ssh root@10.0.0.$startIp ambari-agent start
   echo " finished executing script on host 10.0.0.$startIp."
   ((startIp = startIp + 1))
done

echo "start ambari agent on data nodes...."
startIp=11
for (( d=1; d<=$DATANODES; d++ ))
do
    echo "start ambari agent on host 10.0.0.$startIp ......"
    ssh root@10.0.0.$startIp ambari-agent start
    echo " finished executing script on host 10.0.0.$startIp."
	((startIp = startIp + 1))
done
