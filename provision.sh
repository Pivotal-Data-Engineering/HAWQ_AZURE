#!/bin/sh

cluster_size=$1

cluster_size="${cluster_size:-small}"

echo "cluster_size - >$cluster_size"

if [ "$cluster_size" == "small" ]; then
	MASTERNODES=1
	DATANODES=1
	BLUEPRINT_FILENAME=./blueprints/hawqdl_blueprint_small.json
	BLUEPRINT_TEMPLATE=s./blueprints/hawqdl_template_small.json
	BLUEPRINT_NAME=smallcluster_blueprint
elif [ "$cluster_size" == "medium" ]; then
	MASTERNODES=4
	DATANODES=6
	BLUEPRINT_FILENAME=mediumcluster_blueprint.json
	BLUEPRINT_TEMPLATE=mediumcluster_template.json
	BLUEPRINT_NAME=mediumcluster_blueprint
elif [ "$cluster_size" == "large" ]; then
	MASTERNODES=5
	DATANODES=12
	BLUEPRINT_FILENAME=largecluster_blueprint.json
	BLUEPRINT_TEMPLATE=largecluster_template.json
	BLUEPRINT_NAME=largecluster_blueprint
fi

echo "MASTERNODES=$MASTERNODES,		DATANODES=$DATANODES"


figlet -f digital Pivotal Software

rgName=hawqdatalakeRG

deployTemplateFile=hdp-hawq-datalake-azure.json

#hdp-hawq-datalake-azure.json

parameterFile=hdp-hawq-datalake-azure_parameters.json

#echo "Creating Azure resource group $rgName in region eastus...."

#azure group create -n $rgName -l eastus

echo "Running deployment in group $rgName using $deployTemplateFile and $parameterFile ......"

azure group deployment create -d All -g $rgName -f $deployTemplateFile -e $parameterFile

./post-provision.sh $MASTERNODES $DATANODES $BLUEPRINT_FILENAME $BLUEPRINT_TEMPLATE $BLUEPRINT_NAME



