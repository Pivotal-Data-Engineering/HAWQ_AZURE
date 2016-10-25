#!/bin/sh
numberOfNodes=$1
figlet -f digital Pivotal Software

#echo "setting up ssh configurations ..................."

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com:/home/pivotalpde/.ssh/id_rsa

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key ./ssh_keys/pivotpde_azure.key.pub pivotalpde@hawqdatalake.eastus.cloudapp.azure.com:/home/pivotalpde/.ssh/id_rsa.pub

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com chmod 600 /home/pivotalpde/.ssh/authorized_keys
 
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com   chmod 600 /home/pivotalpde/.ssh/id_rsa

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com chmod 600 /home/pivotalpde/.ssh/id_rsa.pub

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com chmod 700 /home/pivotalpde/.ssh

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com sudo mkdir -p /root/.ssh


ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com sudo cp /home/pivotalpde/.ssh/id_rsa* /root/.ssh

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com sudo cp /home/pivotalpde/.ssh/authorized_keys /root/.ssh 

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/id_rsa

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/id_rsa.pub

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/authorized_keys

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com sudo chmod 700 /root/.ssh

#echo "Finished setting up ssh configurations."

echo "copying the file copyHostNames.sh to ambari node...."
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key copyHostNames.sh pivotalpde@hawqdatalake.eastus.cloudapp.azure.com:/home/pivotalpde/
echo "making file /home/pivotalpde/copyHostNames.sh executable on ambari host...."
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com chmod ug+rwx /home/pivotalpde/copyHostNames.sh
echo "running /home/pivotalpde/copyHostNames.sh $numberOfNodes ...."
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/pivotpde_azure.key pivotalpde@hawqdatalake.eastus.cloudapp.azure.com sh copyHostNames.sh $numberOfNodes

echo "Finished setting up host configurations."
