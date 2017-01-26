#!/bin/sh
cluster_size=large
resourceMgrTemplate=datalake-azure-rm-template.json
resourceMgrParams=datalake-azure-template-parameters-large.json
resourceGroupName=datalakeResourceGroup
region=eastus

HDB_VERSION=2.1.1.0
HDP_VERSION=2.5.3.0
AMB_VERSION=2.4.1.0
PIVOTAL_API_KEY=y7BWf35sarZ6g46GpeLM

./provision.sh $cluster_size $resourceMgrTemplate $resourceMgrParams $resourceGroupName $region $HDB_VERSION $HDP_VERSION $AMB_VERSION $PIVOTAL_API_KEY
