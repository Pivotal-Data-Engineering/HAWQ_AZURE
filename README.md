![alt text](https://github.com/Pivotal-Data-Engineering/HAWQ_AZURE/blob/master/HDB-icon.png "Logo") 
##Pivotal HDB (Powered by Apache HAWQ) 
#### **BETA**
##### The repo provide base automation for installing Hortonworks Data platform 2.5 with Pivotal HAWQ 2.1.1 including Madlib 1.9.1 on Microsoft Azure cloud.

There are three foot prints available to deploy, small, medium, and large. 

```
  - Small cluster has 3 master nodes, 3 data nodes and a administration client node.
  - medium cluster has 3 master nodes, 6 data nodes and one administration node.
  - large cluster has 3 master nodes, 9 data nodes and one adminstration node.
```
## Software versions:
```
   - Centos 6.8
   - Ambari 2.4.2
   - HDP 2.5.3
   - HDB 2.1.1
   - MadLib 1.9.1
   
## VM configuration
```
        Type: DS14 v2
        CPU:  16 Cores
        Memory: 112 GB
        LocalDisk: 224GB SSD
        Storage: Premium_LRS, 1TB/Disk
```    

## Storage Details:
```
   All VMS have a single OS disk.
   Data disks are at different sizes for edgenode, master nodes, and data nodes.
   Edge node Disks: 1x1TB Premium_LRS
   Master node Disks: 2X1TB Premium_LRS
   Data node disks: 6x1TB Premium_LRS (can be changed in https://github.com/Pivotal-Data-Engineering/HAWQ_AZURE/blob/master/datalake-azure-rm-template.json)
```   
## Networking Details   
```
One Subnet is created for entire datalake. Network range is 10.0.0.0/24.
Subnet contain x number of NIC one for each VM.
staic IP addresses are assigned to each ip in the following order
10.0.0.4 Edgenode
10.0.0.5 Masternode0    10.0.0.11 Datanode0
10.0.0.6 Masternode1    10.0.0.12 Datanode1
10.0.0.7 Masternode2    10.0.0.13 Datanode2 .....10.0.0.n DatanodeN

Also dynamic publi IP address is allowede for simiplified access to nodes. 
```
## Provisioning
```
Step 1: mkdir ~/DEV; cd DEV

Step2:  git clone https://github.com/Pivotal-Data-Engineering/HAWQ_AZURE.git
        cd HAWQ_AZURE
Step3: Edit provision-small-cluster.sh and provide your pivnet download key for software from network.pivotal.io.
        PIVOTAL_API_KEY=<download_key_for_pivnet> 
        save and exit.
Step 4: 
        $ chmod ug+rx *.sh
        $ azure login (please refer to Azure cli documentation for this).
          Once logged in to azure cli succcessfully, please run ;
        $ ./provision-small-cluster.sh
        
Step 5. This shold kick off the provision and logs the output on ./logs/ folder.
        you can monitor the progress tailing a most recent log file in logs folder.
        
```        
The script execution foloows the chain of shell script invocations.
#### provision-small-cluster.sh --> provision.sh --> postprovision.sh

The script does below;
```
1. Load Azure RM JSON and Properties
2. Kick off IAAS and run some extension scripts during provision for preparing the VMS.
3. Set up hosts and networking.
4. Download and install Ambari 2.4.2 on edge node. (ambari version is mentioned in provision-small-cluster.sh)
4. install Ambari Agents on all cluster nodes.
5. Download and install HDB2.1 plugins. (hawq version is feed in from provision-small-cluster.sh)
6. Uploads Ambari blueprint for cluster provision. (based on footprint the appropriate BP is selected in provision.sh)
7. Kick off provision and status is printed in the log.
Once the step 7 finished we can monitor the process by logging on to ambari console at 
http://datalakeclient.eastus.cloudapp.azure.com:8080/  using user as 'admin' password as 'admin'
and monitor the install process.
8. Once the provision is finished the script check for hawq install status and if status is good then 
   installs MadLib. If not we need manual investigation*.
```

Login credentials:
```
HAWQ: gpadmin/Gpadmin1
all hive/knox/oozie : Password
```
##### Loginng into edgenode :
```
$ sshOptions="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $HAWQ_AZURE_HOME/ssh_keys/id_rsa"
$ ssh $sshOptions  pivotpde@datalakeclient.eastus.cloudapp.azure.com
  This will log you into edgenode with user pivotpde (password Hawq123)
```  
#### Logging into hawq maser and changing password for gpadmin user
```
    $ sudo su -
    $ ssh masternode1
    $ su gpadmin
    $ source /usr/local/hawq/greenplumpath.sh
    $psql -p 10432
    #alter role gpadmin with password 'Gpadmin1'
    #\q
```    
##### Logging into hawq from edgenode
```
 $ psql -h mansternode1 -p 10432 -U gpadmin  
```

#### TODO:
```
  1. Implement the network topologies
  2. Implment Kerberos authentication
  3. Implement Rack awareness.
  4. Add sample data to hawq and run smoke tests
  5. Add HAWQ ambari view (Beta)
  6. Customize ambari setup
  7. All views and hadoop parts should work with noetwork mappings properly.
  8. Implement any suggestions that team provides.
  
