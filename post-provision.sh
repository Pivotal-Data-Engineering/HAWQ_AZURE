#!/bin/sh

MASTERNODES=$1
DATANODES=$2

BLUEPRINT_FILENAME=$3
BLUEPRINT_TEMPLATE=$4
BLUEPRINT_NAME=$5

sshOptions="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/id_rsa"

echo "setting up ssh configurations $sshOptions ..................."
scp $sshOptions  ./ssh_keys/id_rsa pivotpde@datalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/.ssh/id_rsa
scp $sshOptions  ./ssh_keys/id_rsa.pub pivotpde@datalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/.ssh/id_rsa.pub
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod 640 /home/pivotpde/.ssh/authorized_keys
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com   chmod 600 /home/pivotpde/.ssh/id_rsa
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod 640 /home/pivotpde/.ssh/id_rsa.pub
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod 700 /home/pivotpde/.ssh
##
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "mkdir -p /root/.ssh"'
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "cp /home/pivotpde/.ssh/* /root/.ssh"'
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "cp /home/pivotpde/.ssh/authorized_keys /root/.ssh" '
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 600 /root/.ssh/id_rsa"'
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 640 /root/.ssh/id_rsa.pub"'
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 640 /root/.ssh/authorized_keys"'
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 700 /root/.ssh"'
echo "Finished setting up ssh configurations."
echo "copying the file copyHostNames.sh to ambari node...."
scp $sshOptions copyHostNames.sh pivotpde@datalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/
echo "making file /home/pivotpde/copyHostNames.sh executable on ambari host...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod ugo+rwx /home/pivotpde/copyHostNames.sh
####
echo "running /home/pivotpde/copyHostNames.sh $MASTERNODES $DATANODES ...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com sh copyHostNames.sh $MASTERNODES $DATANODES
echo "Finished setting up host configurations."
#
#echo "getting the domain name. .."
#dldsndomainname=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/id_rsa pivotpde@datalakeclient.eastus.cloudapp.azure.com dnsdomainname)

#echo "replace DOMAIN_NAME with $dldsndomainname in $BLUEPRINT_TEMPLATE ...."
#sed -i -e "s/.DOMAIN_NAME/.${dldsndomainname}/g" $BLUEPRINT_TEMPLATE

#echo "registering the ambari blueprint......"
#curl -u admin:admin -H "X-Requested-By: ambari" -X POST -d @${BLUEPRINT_FILENAME} http://datalakeclient.eastus.cloudapp.azure.com:8080/api/v1/blueprints/${BLUEPRINT_NAME}

#echo "submitting the HDP cluster install ..."
#curl -u admin:admin -X POST -H 'X-Requested-By: ambari' http://datalakeclient.eastus.cloudapp.azure.com:8080/api/v1/clusters/hawqdatalake -d @$BLUEPRINT_TEMPLATE
#echo "cluster install request submitted. check status on the ambari console."

#echo "replace $dldsndomainname with DOMAIN_NAME in $BLUEPRINT_TEMPLATE ...."
#sed -i -e "s/.${dldsndomainname}/.DOMAIN_NAME/g" $BLUEPRINT_TEMPLATE
