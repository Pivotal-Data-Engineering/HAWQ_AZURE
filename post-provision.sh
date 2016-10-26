#!/bin/sh
numberOfNodes=$1
figlet -f digital Pivotal Software

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


ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo cp /home/pivotpde/.ssh/id_rsa* /root/.ssh

ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo cp /home/pivotpde/.ssh/authorized_keys /root/.ssh 

ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/id_rsa

ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/id_rsa.pub

ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/authorized_keys

ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 700 /root/.ssh

#echo "Finished setting up ssh configurations."

echo "copying the file copyHostNames.sh to ambari node...."
scp $sshOptions copyHostNames.sh pivotpde@hawqdatalake.eastus.cloudapp.azure.com:/home/pivotpde/

echo "making file /home/pivotpde/copyHostNames.sh executable on ambari host...."
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com chmod ug+rwx /home/pivotpde/copyHostNames.sh

echo "running /home/pivotpde/copyHostNames.sh $numberOfNodes ...."
ssh $sshOptions  pivotpde@hawqdatalake.eastus.cloudapp.azure.com sh copyHostNames.sh $numberOfNodes

echo "Finished setting up host configurations."
