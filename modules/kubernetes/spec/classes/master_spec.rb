require 'spec_helper'

describe 'kubernetes::master' do
  context 'with normal operation' do
    describe 'with valid ips' do 
      let :params do {
        :master_name => '1.1.1.1',
        :minion_name => ['1.2.1.1']
      } end
      it {should compile.with_all_deps}
      it {should contain_class('kubernetes')}
      it {should contain_file('/etc/kubernetes/config').with_content(/--master=http:\/\/1.1.1.1:8080"/)}
      it {should contain_file('/etc/sysconfig/flanneld').with_content(/FLANNEL_ETCD="http:\/\/1.1.1.1:4001"/)}
      it {should contain_file('/etc/kubernetes/apiserver').with_content(/--etcd_servers=http:\/\/1.1.1.1:4001"/)}
      it {should contain_file('/etc/kubernetes/controller-manager').with_content(/KUBELET_ADDRESSES="--machines=1.2.1.1"/)}

      ['/etc/etcd/etcd.conf', '/tmp/flannel-config.json'].each do |i|
        it {should contain_file(i)} 
      end
      ['etcd', 'kube-apiserver', 'kube-controller-manager', 'kube-scheduler'].each do |i|
        it {should contain_service(i).with_ensure('running').with_enable('true').that_comes_before('Service[flanneld]') }
      end
      ['docker','docker-logrotate','kubernetes','etcd', 'flannel'].each do |i|
        it {should contain_package(i).with_ensure('present')}
      end
      it {should contain_exec('populate etcd server').with({
        :command =>  "curl -L http://1.1.1.1:4001/v2/keys/flannel/network/config -XPUT --data-urlencode value@/tmp/flannel-config.json",
      }).that_notifies('Service[flanneld]') 
      }
    end
    describe 'with valid hostnames' do 
      let :params do {
        :master_name => 'master',
        :minion_name => ['minion']
      } end
      it {should compile}
    end
  end
    describe 'with an array of valid minion ips' do 
      let :params do {
        :master_name => '1.1.1.1',
        :minion_name => ['1.2.1.1','1.3.1.1']
      } end
      it {should compile}
      it {should contain_file('/etc/kubernetes/controller-manager').with_content(/KUBELET_ADDRESSES="--machines=1.2.1.1,1.3.1.1"/)}
  end

  describe 'with a string minion_name' do
    let :params do {
        :master_name => '1.1.1.1',
        :minion_name => '1.2.1.1'
    } end
    it {should_not compile}
  end
end



