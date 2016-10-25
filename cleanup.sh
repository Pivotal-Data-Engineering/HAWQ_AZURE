#!/bin/sh

figlet -f digital Pivotal Software

rgName=hawqdatalakeRG

cleanupTemplateFile=cleanup-all-resources.json

echo "Cleaning all previous resources from $rgName using $cleanupTemplateFile ..................."

azure group deployment create -g $rgName -f $cleanupTemplateFile -m Complete  

echo "Clean up of all resources is finished."

