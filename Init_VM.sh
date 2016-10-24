#!/bin/sh

userName=$1

"sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers"

sudo su -c "echo 0 > /selinux/enforce"
sudo su -c "sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux"
sudo su -c "service iptables stop"
sudo su -c "chkconfig iptables off"
sudo su -c "chkconfig ip6tables off"
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"

sudo su -c 'echo "${userName}    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

#sudo su -c "ssh-keygen -f ~/.ssh/id_rsa1 -t rsa -N "'""'" "
sudo su -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqbpFJ0thyqIwkZkredy+/quI3j3tkssW/gYGPB7JXlOyN9d02F6gOuGiL572CEKuBBghvigFz2zQ4EJR6mxpWdkIz+QLKegNr6osG/apGKa09YDimqsDwDsU++pbAbQ1XzH2xr/gjhsMA22bb4dK9+zPoo+nbJxBWz4HisLj72hYUBhJvYR/ivGi8m61zF3j/ilAJZKm7tjl09zC6qXFUTen8NRnfz7suDBl6+QjzSGdWDnd9PJCWRyQBlj8E/06O8vtHOl2FXYPUq+779y+vNYsGtKKGQ0ApTB/zO1uh6z3X+VP+sN6/VyHrdEf4jqaqutabyUMQSdUPYK1sfJxh' > ~/.ssh/id_rsa.pub"

sudo su -c "chmod 700 ~/.ssh"
sudo su -c "chmod 600 ~/.ssh/authorized_keys"

