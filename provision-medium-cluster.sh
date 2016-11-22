#!/bin/sh
cluster_size=medium
resourceMgrTemplate=datalake-azure-rm-template.json
resourceMgrParams=datalake-azure-template-parameters-small.json
resourceGroupName=datalakeResourceGroup
region=eastus

./provision.sh $cluster_size $resourceMgrTemplate $resourceMgrParams $resourceGroupName $region

