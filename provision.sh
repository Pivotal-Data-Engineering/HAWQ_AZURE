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

