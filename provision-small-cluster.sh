#!/bin/sh
cluster_size=small
resourceMgrTemplate=datalake-azure-rm-template.json
resourceMgrParams=datalake-azure-template-parameters-small.json
resourceGroupName=datalakeResourceGrp
region=eastus
HDB_VERSION=2.1.1.0
HDP_VERSION=2.5.3.0
AMB_VERSION=2.4.2.0
PIVOTAL_API_KEY=<PIVOTAL_API_KEY>

mkdir -p ./logs

./provision.sh $cluster_size $resourceMgrTemplate $resourceMgrParams $resourceGroupName $region $HDB_VERSION $HDP_VERSION $AMB_VERSION $PIVOTAL_API_KEY > ./logs/provision-$(date +"%Y_%m_%d_%I_%M_%p").log 

