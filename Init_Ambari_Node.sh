#!/bin/sh
userName=$1
sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
sudo su -c "echo 0 > /selinux/enforce"
sudo su -c "sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux"
sudo su -c "service iptables stop"
sudo su -c "chkconfig iptables off"
sudo su -c "chkconfig ip6tables off"
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"
sudo su -c 'echo "${userName}    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

#sudo su -c 'ssh-keygen -f /home/${userName}/.ssh/id_rsa1 -t rsa -N "'""'"'"

sudo su -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqbpFJ0thyqIwkZkredy+/quI3j3tkssW/gYGPB7JXlOyN9d02F6gOuGiL572CEKuBBghvigFz2zQ4EJR6mxpWdkIz+QLKegNr6osG/apGKa09YDimqsDwDsU++pbAbQ1XzH2xr/gjhsMA22bb4dK9+zPoo+nbJxBWz4HisLj72hYUBhJvYR/ivGi8m61zF3j/ilAJZKm7tjl09zC6qXFUTen8NRnfz7suDBl6+QjzSGdWDnd9PJCWRyQBlj8E/06O8vtHOl2FXYPUq+779y+vNYsGtKKGQ0ApTB/zO1uh6z3X+VP+sN6/VyHrdEf4jqaqutabyUMQSdUPYK1sfJxh' > ~/.ssh/id_rsa.pub"

sudo su -c " echo '-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAqm6RSdLYcqiMJGZK3ncvv6riN497ZLLFv4GBjweyV5TsjfXd
NheoDrhoi+e9ghCrgQYIb4oBc9s0OBCUepsaVnZCM/kCynoDa+qLBv2qRimtPWA4
pqrA8A7FPvqWwG0NV8x9sa/4I4bDANtm2+HSvfsz6KPp2ycQVs+B4rC4+9oWFAYS
b2Ef4rxovJutcxd4/4pQCWSpu7Y5dPcwuqlxVE3p/DUZ38+7LgwZevkI80hnVg53
fTyQlkckAZY/BP9OjvL7RzpdhV2D1Kvu+/cvrzWLBrSihkNAKUwf8ztboes91/lT
/rDev1ch63RH+I6mqrrWm8lDEEnVD2CtbHycYQIDAQABAoIBAQCSKeMGSgIBS1Vs
/iFlaxgTK614cuAjO0Jme92t2a70d67sDJibhGxHu5VFrwgSnNNJAvCHH/cg8jR1
hJqiD5Tl4+PhCMSA+2Ulzu9OnovCQonlYjkTjsuK1VAKNATHoH7Z9nExyzVm2nMw
r/klyCThc6dP9AtiPL1BhhLhZCgxLLCIh6SwNq99Vl0h8mXV0/Zn8yG9YpNCIx6y
G9FHKs58Z+65OaRLMsT5RpmzRHdpDgEEeHvkQyDllv6ellvOrCh4Yk4r8rWL0qiN
Vf0o435o55X1v6OnSwr3tq+v2uuBm9oaZEzgbNRTLoutcQh59f2ae4SSI3vCE26i
r5/KZzHBAoGBANMJI9tPNUujclbTxQpUeAXOdf/G3YcteMGbST1qdsVlOdoBawKf
RcrYqAS03Xbs4nhIsS1opXqcG1AVo7xG9O339Q/2jx1DhfS7o9TKaSXZ6/dkEFSs
O4Fmr9awgF1dshq8nwpDw8DefCO+8xC08ULcY8EizV6ldqGJZVshmuPZAoGBAM6+
tYlocJbKMRprwy9QXu0eTDJ81h7gbvl8mJ+R0oy1yD5OKsbchUrLm2O/1cUvqZEo
h/9m3f+Ds9hzdLc3sGgVn8rrqKAOEAlGSQTcEqFp4JAZbCti20H3MAblOkiHhJ/Y
yHm05/wRfwrIDjVsjQImYOPYdeH6WoPmjOqk9g/JAoGBAICjyKytutIRnugYjLrA
RK1dbgZtJap56Gs0ClAarq2jB8HBLYbaqcN9j+XWjk0pFt+1h/MjIAP+VpPZrQZe
xnysskB5zkFLYMOPAc37WF8PWMxjvaSvnFJD0xnuW0EOlTvBEL1EE3Zk6I0tn6Lm
eU6FY3VejouMFyVeyF7lvDH5AoGBALeSMECswmOxbj4mdy24sEDcyQ1/OOQ7pW3T
CvWMliYodn+UCnl+bsAF35iHSjmG44onMfI+FVn+SB8mDPlt8i3JHZQhAR30vppt
lQJCoiw+hY2NdTVk1ohRAozs1n52DfWcmA0w61cu9d3N2ofnNaE2EIvetHUNRXee
q3rhNDa5AoGAcq2UFp7Zjn84CXRO71qh+C0/GxqzZ4FknnkumDndWMDm9vihG1Er
qM5o7oeVtrpv+erhqZc3bYEWsroNOXcRvc2jNMXLNeu/FRtD6f9wBwDCyFRKQYdK
4yEIOIz0BZVNhpab6cl2HUJ4uJ1x+b3ctCT/n08ZrfNfpwMbl/0b3RA=
-----END RSA PRIVATE KEY-----' > ~/.ssh/id_rsa"


sudo su -c "chmod 700 ~/.ssh"
sudo su -c "chmod 600 ~/.ssh/authorized_keys"

sudo su -c "wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -P /etc/yum.repos.d/"
sudo su -c "yum install -y ambari-server"
sudo su -c "ambari-server setup -s"
sudo su -c "ambari-server start"












