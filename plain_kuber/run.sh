# FROM http://severalnines.com/blog/installing-kubernetes-cluster-minions-centos7-manage-pods-services
# flannel must be tied to eth1  FLANNEL_OPTIONS="--iface=eth1" in /etc/sysconfig/flanneld. This must apply on ALL flannel installations, master AND nodes
yum install docker -y
yum  -y install ntp -y 
systemctl start ntpd
systemctl enable ntpd
setenforce 0
groupadd docker
gpasswd -a vagrant docker
service docker start
service firewalld stop
