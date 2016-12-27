# Azure_HAWQ_Pilot
The repo provide base automation for installing Hortonworks Data platform 2.5 along with Pivotal HAWQ 2.1.1.
There are three foot prints available to deploy, small, medium, and large. 
Small foot print has 6 node hadoop clister with 3 master nodeas and 3 data nodes and a administration client node.
medium foot prints has 4 master nodes, 6 data nodes and one administration node.
large foot print has 4 master nodes, 10 data nodes and one adminstration node.


All the nodes are of type "Standard_DS14".

Data nodes will have a attached disks of size 2x2TB. More disks can be added if needed.

Since this is a pilot i have resources that need internal pivotal github permissions.

To standup a small dev cluster please clone the repo. After cloning the repo navigate to the repo location in the local drive and login to azure-cli.

Once login succcessfully please run ./provision-small-cluster.sh
