#!/bin/sh
PIVOTAL_API_KEY=$1

export PIV_NET_BASE=https://network.pivotal.io/api/v2/products/pivotal-hdb/releases/3466
export PIV_NET_HDB=$PIV_NET_BASE/product_files/10946/download
export PIV_NET_ADDON=$PIV_NET_BASE/product_files/10947/download
export PIV_NET_MADLIB=$PIV_NET_BASE/product_files/10951/download
export PIV_NET_EULA=$PIV_NET_BASE/eula_acceptance


echo "downloading hawq software ...."
echo "Accept Pivotal EULA"
echo "USING PIVNET API KEY --> " $PIVOTAL_API_KEY

export headers="{Authorization:Token $PIVOTAL_API_KEY}"

echo "headers = $headers"

curl -X POST --header "Authorization: Token $PIVOTAL_API_KEY" $PIV_NET_EULA


echo "downloading from ..."
echo $PIV_NET_HDB

sudo su -c "mkdir -p /staging/madlib"
sudo su -c "chmod -R a+rwx /staging"

wget -O "/staging/Pivotal_HDB.tar.gz" --post-data="" --header="Authorization: Token $PIVOTAL_API_KEY" $PIV_NET_HDB 
wget -O "/staging/Pivotal_HDB-addons.tar.gz" --post-data="" --header="Authorization: Token $PIVOTAL_API_KEY" $PIV_NET_ADDON 
wget -O "/staging/MadLib.tar.gz" --post-data="" --header="Authorization: Token $PIVOTAL_API_KEY" $PIV_NET_MADLIB 

echo "extracting hawq download ...."
tar -xvzf /staging/Pivotal_HDB.tar.gz -C /staging 
tar -xvzf /staging/Pivotal_HDB-addons.tar.gz -C /staging/ 
tar -xvzf /staging/MadLib.tar.gz -C /staging/madlib

echo " setting local repo for hdb...."
cd /staging/hdb-2*
sudo su -c " ./setup_repo.sh "

echo " setting local repo for hdb-addon...."
cd /staging/hdb-add*
sudo su -c " ./setup_repo.sh  "

echo " installing hdb ambari plugin ...."
sudo su -c " yum install -y hawq-ambari-plugin "
sudo su -c " /var/lib/hawq/add-hawq.py -u admin -p admin --stack HDP-2.5"

#restart Ambari
echo "Restarting Ambari..."
sudo su -c "ambari-server restart"

sleep 10

curl -u admin:admin -H  X-Requested-By:ambari http://localhost:8080/api/v1/hosts




