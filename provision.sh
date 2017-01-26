#!/bin/sh

cluster_size=$1
resourceMgrTemplate=$2
resourceMgrTemplateParams=$3
resourceGroupName=$4
region=$5
HDB_VERSION=$6
HDP_VERSION=$7
AMB_VERSION=$8   
PIVOTAL_API_KEY=$9

if [ $# -eq 0 ] ; then
	echo "\nusage: \n\tprovision.sh <cluster_size> <resourceManagerTemplate> <resourceManagerTemplateParameters> <resourceGroupName> <region>"
	exit 1
fi

if [ -z "$1" ]; then
    echo "\nplease secify cluster size {small|medium|large}"
	exit 1
fi
if [ -z "$2" ]; then
    echo "\nplease secify azure resource manager JSON template."
	exit 1
fi
if [ -z "$3" ]; then
    echo "\nplease secify azure resource manager JSON template parameters."
	exit 1
fi
if [ -z "$4" ]; then
    echo "\nplease secify azure resource group name."
	exit 1
fi
if [ -z "$5" ]; then
    echo "\nplease secify azure region."
	exit 1
fi

if [ -z "$6" ]; then
    echo "\nplease secify Pivotal HDB version."
	exit 1
fi
if [ -z "$7" ]; then
    echo "\nplease secify Hortonworks Data platform version"
	exit 1
fi
if [ -z "$8" ]; then
    echo "\nplease secify Ambari Version."
	exit 1
fi
if [ -z "$9" ]; then
    echo "\nplease secify Token for Pivnet to download hawq"
	exit 1
fi

if [ "$cluster_size" == "small" ]; then
	DATANODES=3
	MASTERNODES=3
	BLUEPRINT_FILENAME=AMBARI_BLUEPRINT_HDP251Hawq21_SMALL.JSON
	BLUEPRINT_TEMPLATE=AMBARI_BLUEPRINT_HDP251Hawq21_SMALL_TEMPLATE.JSON
	BLUEPRINT_NAME=datalake_blueprint
elif [ "$cluster_size" == "medium" ]; then
	MASTERNODES=4
	DATANODES=6
	BLUEPRINT_FILENAME=AMBARI_BLUEPRINT_HDP251Hawq21_MEDIUM.JSON
	BLUEPRINT_TEMPLATE=AMBARI_BLUEPRINT_HDP251Hawq21_MEDIUM_TEMPLATE.JSON
	BLUEPRINT_NAME=hawqdatalake_blueprint
elif [ "$cluster_size" == "large" ]; then
	MASTERNODES=5
	DATANODES=12
	BLUEPRINT_FILENAME=AMBARI_BLUEPRINT_HDP251Hawq21_LARGE.JSON
	BLUEPRINT_TEMPLATE=AMBARI_BLUEPRINT_HDP251Hawq21_LARGE_TEMPLATE.JSON
	BLUEPRINT_NAME=hawqdatalake_blueprint
fi
echo "\n"
figlet -f digital Pivotal Software
echo "\n"
echo "************************************************************************************************"
echo "\n"
echo "Provision a Hortonworks hadoop cluster with Pivotal Hawq with below specification."
echo "cluster_size -> $cluster_size [ $MASTERNODES master nodes, and $DATANODES data nodes. ]"
echo "Resource Manager Template -> $resourceMgrTemplate"
echo "Resource Mangaer Parameters -> $resourceMgrTemplateParams"
echo "Resource Group name -> $resourceGroupName"
echo "\n"
echo "************************************************************************************************"

echo "\nCreating Azure resource group $resourceGroupName in region eastus...."
azure group create -n $resourceGroupName -l $region
echo "\nRunning deployment in group $resourceGroupName using $resourceMgrTemplate and $resourceMgrTemplateParams ......"
azure group deployment create -d All -g $resourceGroupName -f $resourceMgrTemplate -e $resourceMgrTemplateParams
echo "\ninvoking postprovision script......"
./post-provision.sh $MASTERNODES $DATANODES $BLUEPRINT_FILENAME $BLUEPRINT_TEMPLATE $BLUEPRINT_NAME $HDB_VERSION $HDP_VERSION $AMB_VERSION $PIVOTAL_API_KEY
#echo "\n Finished provisioning the cluster."


