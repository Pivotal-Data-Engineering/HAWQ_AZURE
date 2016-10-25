#!/bin/sh

startIp=5
numOfHosts=$1

rm -f /home/pivotalpde/hdphosts.txt

for (( c=1; c<=$numOfHosts; c++ ))
do
   echo "" >> /home/pivotalpde/hdphosts.txt	
   ssh root@10.0.0.$startIp 'hostname -I;hostname -f;hostname '| tr '\n' "      ">> /home/pivotalpde/hdphosts.txt
   ((startIp = startIp + 1))
done

sudo su -c "cat hdphosts.txt >> /etc/hosts"

startIp=5

for (( c=1; c<=$numOfHosts; c++ ))
do
   sudo su -c "scp /etc/hosts root@10.0.0.$startIp:/etc/hosts "
   ((startIp = startIp + 1))
done