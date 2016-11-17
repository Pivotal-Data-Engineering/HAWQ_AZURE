#!/bin/sh

figlet -f digital Pivotal Software

resourceGrpName=$1 

resourceGrpName="${resourceGrpName:-datalakeResourceGrp}"

cleanupTemplateFile=cleanup-all-resources.json

echo "Cleaning all previous resources from $ourceGrpName using $cleanupTemplateFile ..................."

azure group deployment create -g $resourceGrpName -f $cleanupTemplateFile -m Complete  

echo "Clean up of all resources is finished."

