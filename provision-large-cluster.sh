#!/bin/sh
cluster_size=large
resourceMgrTemplate=datalake-azure-rm-template.json
resourceMgrParams=datalake-azure-template-parameters-large.json
resourceGroupName=datalakeResourceGroup
region=eastus

./provision.sh $cluster_size $resourceMgrTemplate $resourceMgrParams $resourceGroupName $region

