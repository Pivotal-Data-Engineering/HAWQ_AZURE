#!/bin/sh
cluster_size=small
resourceMgrTemplate=datalake-azure-rm-template.json
resourceMgrParams=datalake-azure-template-parameters-small.json
resourceGroupName=datalakeResourceGrp
region=eastus

./provision.sh $cluster_size $resourceMgrTemplate $resourceMgrParams $resourceGroupName $region

