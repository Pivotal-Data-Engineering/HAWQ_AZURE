#!/bin/sh

DATANODES=$1
MASTERNODES=$2
BLUEPRINT_FILENAME=$3
BLUEPRINT_TEMPLATE=$4
BLUEPRINT_NAME=$5
HDB_VERSION=$6
HDP_VERSION=$7
AMB_VERSION=$8
PIVOTAL_API_KEY=$9

sshOptions="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./ssh_keys/id_rsa"

#echo "setting up ssh configurations $sshOptions ..................."
scp $sshOptions  ./ssh_keys/id_rsa pivotpde@datalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/.ssh/id_rsa
scp $sshOptions  ./ssh_keys/id_rsa.pub pivotpde@datalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/.ssh/id_rsa.pub
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod 640 /home/pivotpde/.ssh/authorized_keys
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com   chmod 600 /home/pivotpde/.ssh/id_rsa
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod 640 /home/pivotpde/.ssh/id_rsa.pub
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod 700 /home/pivotpde/.ssh

ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "mkdir -p /root/.ssh"'
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "cp /home/pivotpde/.ssh/* /root/.ssh"'
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "cp /home/pivotpde/.ssh/authorized_keys /root/.ssh" '
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 600 /root/.ssh/id_rsa"'
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 640 /root/.ssh/id_rsa.pub"'
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 640 /root/.ssh/authorized_keys"'
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com 'sudo su -c "chmod 700 /root/.ssh"'
echo "Finished setting up ssh configurations."

echo "***************************** SECTION 1 BEGIN *****************************"
echo "copying the file copyHostNames.sh to ambari node...."
scp $sshOptions copyHostNames.sh pivotpde@datalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/
echo "making file /home/pivotpde/copyHostNames.sh executable on ambari host...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod ugo+rwx /home/pivotpde/copyHostNames.sh
echo "running /home/pivotpde/copyHostNames.sh $MASTERNODES $DATANODES ...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com sh copyHostNames.sh $MASTERNODES $DATANODES
echo "Finished setting up host configurations."


echo "***************************** SECTION 2 BEGIN *****************************"
echo "copying the file Install_Ambari_Server.sh to ambari node...."
scp $sshOptions Install_Ambari_Server.sh pivotpde@datalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/
echo "making file /home/pivotpde/Install_Ambari_Server.sh executable on ambari host...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod ugo+rwx /home/pivotpde/Install_Ambari_Server.sh
echo "running /home/pivotpde/Install_Ambari_Server.sh ...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com sh Install_Ambari_Server.sh $AMB_VERSION
echo "Finished Installing up Ambari Server."
sleep 30

echo "***************************** SECTION 3 BEGIN *****************************"
echo "copying the file Install_Ambari_Agent.sh to ambari node...."
scp $sshOptions Install_Ambari_Agent.sh pivotpde@datalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/
echo "making file /home/pivotpde/Install_Ambari_Agent.sh executable on ambari host...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod ugo+rwx /home/pivotpde/Install_Ambari_Agent.sh
echo "running /home/pivotpde/Install_Ambari_Agent.sh $MASTERNODES $DATANODES ...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com sh Install_Ambari_Agent.sh $MASTERNODES $DATANODES $AMB_VERSION
echo "Finished installing  Ambari Agents."

sleep 30

echo "***************************** SECTION 4 BEGIN *****************************"
echo "copying the file Install_Hawq_plugin.sh to ambari node...."
scp $sshOptions Install_Hawq_plugin.sh pivotpde@datalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/
echo "making file /home/pivotpde/Install_Hawq_plugin.sh executable on ambari host...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod ugo+rwx /home/pivotpde/Install_Hawq_plugin.sh
echo "running /home/pivotpde/Install_Hawq_plugin $PIVOTAL_API_KEY ...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com sh Install_Hawq_plugin.sh $PIVOTAL_API_KEY
echo "Finished Downloding hawq sw and installing  Hawq ambbari plug-in."
sleep 30

echo "***************************** SECTION 5 BEGIN *****************************"
echo "registering the ambari blueprint......"
curl -u admin:admin -H "X-Requested-By: ambari" -X POST -d @${BLUEPRINT_FILENAME} http://datalakeclient.eastus.cloudapp.azure.com:8080/api/v1/blueprints/${BLUEPRINT_NAME}

echo "submitting the HDP cluster install ..."
curl -u admin:admin -X POST -H 'X-Requested-By: ambari' http://datalakeclient.eastus.cloudapp.azure.com:8080/api/v1/clusters/hawqdatalake -d @$BLUEPRINT_TEMPLATE
echo "cluster install request submitted. check status on the ambari console."
sleep 30

ProgressPercent=0

while [[ `echo $ProgressPercent | grep -v 100` ]]; do
  ProgressPercent=`curl -s --user admin:admin -H 'X-Requested-By:ambari' -X GET http://datalakeclient.eastus.cloudapp.azure.com:8080/api/v1/clusters/hawqdatalake/requests/1 | grep progress_percent | awk '{print $3}' | cut -d . -f 1`
  tput cuu1
  echo ""
  echo "cluster build Progress: $ProgressPercent % cluster"
  sleep 2
done

echo "Cluster build is complete."

echo "***************************** SECTION 6 BEGIN *****************************"
echo "Checking Hawq Status ....."

(curl -u ambaridmin:admin -X GET -H 'X-Requested-By:ambari' http://datalakeclient.eastus.cloudapp.azure.com:8080/api/v1/clusters/hawqdatalake/services/HAWQ | grep -q state | grep -q STARTED) && echo "STARTED" || export started=yes
if [ "$started" == "yes" ]; then
	echo "copying the file Install_MadLib.sh to ambari node...."
  	scp $sshOptions Install_MadLib.sh pivotpde@datalakeclient.eastus.cloudapp.azure.com:/home/pivotpde/ 
	echo "making file /home/pivotpde/Install_MadLib.sh executable on ambari host...."
	ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com chmod ugo+rwx /home/pivotpde/Install_MadLib.sh
	echo "running /home/pivotpde/Install_MadLib ...."
	ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com sh Install_MadLib.sh
else
	echo "HAWQ seems to not up. Please visit http://datalakeclient.eastus.cloudapp.azure.com:8080 for troubleshoot."
fi

echo "cleaning the install scripts...."
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com "rm -f /home/pivotpde/Install_*.sh"
ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com "rm -f /home/pivotpde/copyHostNames.sh"

echo "Process finished!"
	
	
  

