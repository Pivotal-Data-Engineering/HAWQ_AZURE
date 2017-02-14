echo "Installing lending_club demo schema....."
export PGPASSWORD=Gpadmin1
ech o"creating demouser and database ......"
psql -p 10432 -U gpadmin -d postgres -h masternode1 -w -c "create role demouser login password 'hawqdemo' SUPERUSER INHERIT CREATEDB CREATEROLE RESOURCE QUEUE pg_default"

echo "creating analyticsdb ......"
psql -p 10432 -U gpadmin -d postgres -h masternode1 -w -c "CREATE DATABASE analyticsdb WITH ENCODING='UTF-8' OWNER=demouser CONNECTION LIMIT=-1"

echo "open access to deomuser with password for anywhere ......"
ssh masternode1 'sudo su -c  "echo '\''host     all     demouser     0.0.0.0/0     password'\'' >> /data/hawq/master/pg_hba.conf " '

echo "reloading hawq config ......"
ssh masternode1 " sudo -u gpadmin bash -c 'source /usr/local/hawq/greenplum_path.sh; hawq stop cluster -a -u -M fast' ";
i
export PGPASSWORD=

echo "load lending_club data to hawq....."
echo "Downloading the schema file from https://pivotalhdb01.blob.core.windows.net/lendingclub-demo-data/lc_demo_ddl_load_data.sql ......"
wget -O "/staging/lc_demo_ddl_load_data.sql" https://pivotalhdb01.blob.core.windows.net/lendingclub-demo-data/lc_demo_ddl_load_data.sql
export PGPASSWORD=hawqdemo
echo "Start running schema sql ......"
psql -p 10432 -U demouser -d analyticsdb -h masternode1 -w -f /staging/lc_demo_ddl_load_data.sql
export PGPASSWORD=
echo "Finished running schema sql."