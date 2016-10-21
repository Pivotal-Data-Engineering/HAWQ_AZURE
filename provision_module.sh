#!/bin/sh

rgName=datalake01-rg

templateFile=/Users/spaladugu/DEV/github/HAWQ_AZURE/azure_deploy_hdp.json

parameterFile=/Users/spaladugu/DEV/github/HAWQ_AZURE/hdb-dl-ambari-azure.parameters.json

#echo 'Creating Azure resource group $rgName in region eastus....'

#azure group create -n $rgName -l eastus


echo 'Running deployment in group $rgName using $templateFile and $parameterFile ......'

azure group deployment create -d All -g $rgName -f $templateFile -e $parameterFile

