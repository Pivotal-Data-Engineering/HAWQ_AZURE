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
scp $sshOptions  ./ssh_keys/id_rsa pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/.ssh/id_rsa
scp $sshOptions  ./ssh_keys/id_rsa.pub pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/.ssh/id_rsa.pub
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com chmod 640 /home/pivotpde/.ssh/authorized_keys
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com   chmod 600 /home/pivotpde/.ssh/id_rsa
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com chmod 640 /home/pivotpde/.ssh/id_rsa.pub
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com chmod 700 /home/pivotpde/.ssh

ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com 'sudo su -c "mkdir -p /root/.ssh"'
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com 'sudo su -c "cp /home/pivotpde/.ssh/* /root/.ssh"'
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com 'sudo su -c "cp /home/pivotpde/.ssh/authorized_keys /root/.ssh" '
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 600 /root/.ssh/id_rsa"'
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 640 /root/.ssh/id_rsa.pub"'
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 640 /root/.ssh/authorized_keys"'
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 700 /root/.ssh"'
echo "Finished setting up ssh configurations."


echo "copying the file copyHostNames.sh to ambari node...."
scp $sshOptions copyHostNames.sh pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/
echo "making file /home/pivotpde/copyHostNames.sh executable on ambari host...."
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com chmod ugo+rwx /home/pivotpde/copyHostNames.sh

echo "copying the file install-hawq.sh to ambari node...."
scp $sshOptions install-hawq.sh pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/
echo "making file /home/pivotpde/install-hawq.sh executable on ambari host...."
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com chmod ugo+rwx /home/pivotpde/install-hawq.sh

echo "running /home/pivotpde/copyHostNames.sh $numberOfNodes ...."
ssh $sshOptions  pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com sh copyHostNames.sh $MASTERNODES $DATANODES
echo "Finished setting up host configurations."

echo "getting the domain name. .."
dldsndomainname=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/id_rsa pivotpde@hawqdatalakeclient.eastus.cloudapp.azure.com dnsdomainname)

echo "replace DOMAIN_NAME with $dldsndomainname in $BLUEPRINT_TEMPLATE ...."
sed -i -e "s/.DOMAIN_NAME/.$dldsndomainname/g" $BLUEPRINT_TEMPLATE

echo "registering the ambari blueprint......"
curl -u admin:admin -H "X-Requested-By: ambari" -X POST -d @${BLUEPRINT_FILENAME} http://hawqdatalakeclient.eastus.cloudapp.azure.com:8080/api/v1/blueprints/${BLUEPRINT_NAME}

echo "submitting the HDP cluster install ..."
curl -u admin:admin -X POST -H 'X-Requested-By: ambari' http://hawqdatalakeclient.eastus.cloudapp.azure.com:8080/api/v1/clusters/hawqdatalake -d @$BLUEPRINT_TEMPLATE
echo ">>>>>>>>>>  cluster install request submitted. check status on the ambari console. <<<<<<<<<<<<<"
#echo "Once the cluster is installed and all components are running properly you can install hawq by ssh into ambari node and run below commands:"
#echo " 1. sudo su -"
#echo " 2. cd /home/pivotpde"
#echo " 3. ./install-hawq.sh"

echo "replace $dldsndomainname with DOMAIN_NAME in $BLUEPRINT_TEMPLATE ...."
sed -i -e "s/.$dldsndomainname/.DOMAIN_NAME/g" $BLUEPRINT_TEMPLATE
