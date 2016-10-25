#!/bin/sh
figlet -f digital Pivotal Software

echo "setting up ssh configurations ..................."

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com:/home/eviCore/.ssh/id_rsa

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key ~/.ssh/pivotpde_azure.key.pub eviCore@datalakepde.eastus.cloudapp.azure.com:/home/eviCore/.ssh/id_rsa.pub

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com chmod 600 /home/eviCore/.ssh/authorized_keys
 
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com   chmod 600 /home/eviCore/.ssh/id_rsa

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com chmod 600 /home/eviCore/.ssh/id_rsa.pub

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com chmod 700 /home/eviCore/.ssh

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com sudo mkdir -p /root/.ssh

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com sudo cp /home/eviCore/.ssh/id_rsa* /root/.ssh

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com sudo cp /home/eviCore/.ssh/authorized_keys /root/.ssh 

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/id_rsa

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/id_rsa.pub

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com sudo chmod 600 /root/.ssh/authorized_keys

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/pivotpde_azure.key eviCore@datalakepde.eastus.cloudapp.azure.com sudo chmod 700 /root/.ssh

echo "Finished setting up ssh configurations."