#!/bin/sh

MASTERNODES=$1
DATANODES=$2

$BLUEPRINT_FILENAME=$3
$BLUEPRINT_TEMPLATE=$4
$BLUEPRINT_NAME=$5

sshOptions="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/id_rsa"

echo "setting up ssh configurations ..................."
echo $sshOptions
echo "............"
scp $sshOptions  ./ssh_keys/id_rsa pivotpde@hawqdatalake.eastus.cloudapp.azure.com:/home/pivotpde/.ssh/id_rsa
scp $sshOptions  ./ssh_keys/id_rsa.pub pivotpde@hawqdatalake.eastus.cloudapp.azure.com:/home/pivotpde/.ssh/id_rsa.pub
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com chmod 600 /home/pivotpde/.ssh/authorized_keys
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com   chmod 600 /home/pivotpde/.ssh/id_rsa
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com chmod 600 /home/pivotpde/.ssh/id_rsa.pub
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com chmod 700 /home/pivotpde/.ssh

ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo mkdir -p /root/.ssh
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo cp /home/pivotpde/.ssh/* /root/.ssh
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo cp /home/pivotpde/.ssh/authorized_keys /root/.ssh 
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/id_rsa
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/id_rsa.pub
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/authorized_keys
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 700 /root/.ssh
echo "Finished setting up ssh configurations."


echo "copying the file copyHostNames.sh to ambari node...."
scp $sshOptions copyHostNames.sh pivotpde@hawqdatalake.eastus.cloudapp.azure.com:/home/pivotpde/
echo "making file /home/pivotpde/copyHostNames.sh executable on ambari host...."
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com chmod ug+rwx /home/pivotpde/copyHostNames.sh
echo "running /home/pivotpde/copyHostNames.sh $numberOfNodes ...."
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sh copyHostNames.sh $MASTERNODES $DATANODES
echo "Finished setting up host configurations."

echo "copying the ambari blue prints for $cluster_size cluster to ambari node...."
scp $sshOptions smallcluster*json pivotpde@hawqdatalake.eastus.cloudapp.azure.com:/home/pivotpde/

#echo "registering the ambari blueprint......"
#curl -u admin:admin -H "X-Requested-By: ambari" -X POST -d @./${BLUEPRINT_FILENAME} http://hawqdatalake.eastus.cloudapp.azure.com:8080//api/v1/blueprints/${BLUEPRINT_NAME}

#scp hawq tar files
#mkdir /staging, extract tars in staging and run setup repo, stop ambari-server, yum install -y hawq-ambari-plugin, start amnbari-server

# pivotal API y7BWf35sarZ6g46GpeLM







