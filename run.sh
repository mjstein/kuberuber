setenforce 0
service firewalld stop
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum install puppetserver -y 
