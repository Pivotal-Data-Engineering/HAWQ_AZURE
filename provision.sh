#!/bin/sh

numberOfNodes=$1

figlet -f digital Pivotal Software

rgName=hawqdatalakeRG

deployTemplateFile=/Users/spaladugu/DEV/github/HAWQ_AZURE/hdp-hawq-datalake-azure.json

#hdp-hawq-datalake-azure.json

parameterFile=/Users/spaladugu/DEV/github/HAWQ_AZURE/hdp-hawq-datalake-azure_parameters.json

#echo "Creating Azure resource group $rgName in region eastus...."

#azure group create -n $rgName -l eastus

echo "Running deployment in group $rgName using $deployTemplateFile and $parameterFile ......"

#azure group deployment create -d All -g $rgName -f $deployTemplateFile -e $parameterFile

./post-provision.sh $numberOfNodes



