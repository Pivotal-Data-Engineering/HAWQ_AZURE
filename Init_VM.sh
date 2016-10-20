!/bin/sh
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"
sudo su -c "echo 0 > /selinux/enforce"
sudo su -c 'sed -i -e "s/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux"
sudo su -c "service iptables stop"
sudo su -c "chkconfig iptables off"
sudo su -c "chkconfig ip6tables off"
