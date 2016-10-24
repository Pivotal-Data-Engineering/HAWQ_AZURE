#!/bin/sh

figlet -f digital Pivotal Software

rgName=datalake01-rg

cleanupTemplateFile=/Users/spaladugu/DEV/github/HAWQ_AZURE/cleanup-all-resources.json

deployTemplateFile=/Users/spaladugu/DEV/github/HAWQ_AZURE/hdp-hawq-datalake-azure.json

#hdp-hawq-datalake-azure.json

parameterFile=/Users/spaladugu/DEV/github/HAWQ_AZURE/hdp-hawq-datalake-azure_parameters.json

#echo 'Creating Azure resource group $rgName in region eastus....'

#azure group create -n $rgName -l eastus

echo 'Cleaning all previous resources from $rgName ...................'

azure group deployment create -g $rgName -f $cleanupTemplateFile -m Complete  

echo 'Running deployment in group $rgName using $hdp-hawq-datalake-azure and $parameterFile ......'

azure group deployment create -d All -g $rgName -f $deployTemplateFile -e $parameterFile


scp -i ~/.ssh/pivotpde_azure.key  eviCore@datalakepde.eastus.cloudapp.azure.com:/home/eviCore/.ssh/id_rsa
scp -i ~/.ssh/pivotpde_azure.key.pub eviCore@datalakepde.eastus.cloudapp.azure.com:/home/eviCore/.ssh/id_rsa.pub
ssh -i ~/.ssh/pivotpde_azure.key -c  "chmod 600 /home/eviCore/.ssh/authorized_keys"
ssh -i ~/.ssh/pivotpde_azure.key -c  "chmod 600 /home/eviCore/.ssh/id_rsa"
ssh -i ~/.ssh/pivotpde_azure.key -c  "chmod 600 /home/eviCore/.ssh/id_rsa.pub"
ssh -i ~/.ssh/pivotpde_azure.key -c  "chmod 700 /home/eviCore/.ssh"


ssh -i ~/.ssh/pivotpde_azure.key -c  "mkdir -p /root/.ssh"
ssh -i ~/.ssh/pivotpde_azure.key -c  "sudo su -c 'cp /home/eviCore/.ssh/id_rsa*' /root/.ssh' "
ssh -i ~/.ssh/pivotpde_azure.key -c  "sudo su -c 'cp /home/eviCore/.ssh/authorized_keys' /root/.ssh' "
ssh -i ~/.ssh/pivotpde_azure.key -c  "sudo su -c 'chmod 600 /root/.ssh/id_rsa'"
ssh -i ~/.ssh/pivotpde_azure.key -c  "sudo su -c 'chmod 600 /root/.ssh/id_rsa.pub'"
ssh -i ~/.ssh/pivotpde_azure.key -c  "sudo su -c 'chmod 600 /root/.ssh/authorized_keys'"
ssh -i ~/.ssh/pivotpde_azure.key -c  "sudo su -c 'chmod 700 /root/.ssh'"