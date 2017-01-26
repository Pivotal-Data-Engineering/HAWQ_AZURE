# Azure_HAWQ_Pilot
The repo provide base automation for installing Hortonworks Data platform 2.5 along with Pivotal HAWQ 2.1.1.
There are three foot prints available to deploy, small, medium, and large. 
Small foot print has 6 node hadoop clister with 3 master nodeas and 3 data nodes and a administration client node.
medium foot prints has 4 master nodes, 6 data nodes and one administration node.
large foot print has 4 master nodes, 10 data nodes and one adminstration node.


All the nodes are of type "Standard_DS12_v2". You can change the parameters in the appropriate deployment properties files, for ex: datalake-azure-template-parameters-small.json.

Data nodes will have a attached disks of size 4x1TB. More disks can be added if needed.

To standup a small dev cluster please clone the repo. After cloning the repo navigate to the repo location in the local drive and login to azure-cli.

Once logged in to azure cli succcessfully, please run ./provision-small-cluster.sh.

This shold kick off the provision and logs the output on ./logs/ folder.
Essecntially the script does below;
1. Load Azure RM JSON and Properties
2. Kick off IAAS and run some extension scripts during provision for preparing the VMS.
3. Set up hosts and networking.
4. Download and install Ambari 2.4.1(configurable) on edge node.
4. install Ambari Agents on all cluster nodes.
5. Download and install HDB2.1 plugins.
6. Upload Ambari blueprint for cluster provision.
7. Kick off provision.

Once the step 7 finished we can monitor the process by logging on to ambari console at 
http://datalakeclient.eastus.cloudapp.azure.com:8080/
and monitor the install process.

**TODO: noticed sometimes someof the services are failing to start during provision.
        Please stop all the services via ambari after complted the install and start all services.
        
