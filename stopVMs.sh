#!/bin/sh

resourceGroup=$1
if [ $# -eq 0 ] ; then
	echo "Please provide resourceGroupName"
	exit 1
fi
echo "stopping and deallocating Virtual machines in $resourceGroup"
vms=$(azure vm list  $resourceGroup | awk '{print $3}'|awk 'FNR > 4')
for vm in $vms; 
do
	echo "running azure vm deallocate $regourceGroup $vm "
	azure vm deallocate $regourceGroup $vm 
done

echo "finished processing all VMs."
