#!/bin/sh

echo "Installing madlib to hawq....."

ssh masternode1 "sudo su -c 'mkdir /staging' "

echo "copying files hawq master node ..."

sudo su -c "scp -r /staging/madlib masternode1:/staging/madlib"

ssh masternode1 "sudo su -c 'chmod -R a+rx /staging/madlib' "

echo "running gppkg -i /staging/madlib/madlib*.gppkg ........."

ssh masternode1 "sudo -u gpadmin bash -c 'source /usr/local/hawq/greenplum_path.sh;gppkg -i /staging/madlib/madlib*.gppkg' "

echo"removing the compression ......"
ssh masternode1 "sudo -u gpadmin bash -c 'source /usr/local/hawq/greenplum_path.sh;/staging/madlib/remove_compression.sh --prefix /usr/local/hawq/madlib'"

echo "installing madlib schema to template1 ......"
ssh masternode1 "sudo -u gpadmin bash -c 'source /usr/local/hawq/greenplum_path.sh; /usr/local/hawq/madlib/bin/madpack install -s madlib -p hawq -c gpadmin@masternode1:10432/template1'"

echo "installing madlib schema to gpadmin ......"
ssh masternode1 "sudo -u gpadmin bash -c 'source /usr/local/hawq/greenplum_path.sh; /usr/local/hawq/madlib/bin/madpack install -s madlib -p hawq -c gpadmin@masternode1:10432/gpadmin'"

echo "Finished installing madlib......"

echo "open access to HAWQ with password for anywhere ......"
ssh masternode1 "sudo -u gpadmin echo 'host  all     gpadmin    0.0.0.0/0      password' >> /data/hawq/master/pg_hba.conf "

echo "reloading hawq config ......"
sh masternode1 " sudo -u gpadmin bash -c 'source /usr/local/hawq/greenplum_path.sh; hawq stop cluster -a -u -M fast' ";