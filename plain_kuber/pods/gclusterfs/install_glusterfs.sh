#dd if=/dev/zero of=/dev/sdb bs=512 count=1
#mkfs.xfs -i size=512 /dev/sdb
#mkdir -p /data/brick1
#echo '/dev/sdb /data/brick1 xfs defaults 1 2' >> /etc/fstab
#mount -a && mount
yum install epel-release -y
yum install  centos-release-gluster -y
yum install glusterfs-server -y
service glusterd start

#probe for server 1
gluster peer probe 10.74.50.253 # serverspecific
mkdir -p /data/brick1/gv0
gluster volume create gv0 replica 2 10.74.55.28:/data/brick1/gv0 10.74.50.253:/data/brick1/gv0 #from any server
gluster volume start gv0

# install heketi
#yum install heketi -y
# config file here
#systemctl start heketi
