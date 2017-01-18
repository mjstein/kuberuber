require 'spec_helper'

describe 'kubernetes::minion' do
  context 'with normal operation' do
    describe 'with valid ips' do 
      let :params do {
        :master_name => '1.1.1.1',
        :minion_name => '1.2.1.1'
      } end
      it {should compile}
      it {should contain_class('kubernetes')}
      it {should contain_file('/etc/kubernetes/kubelet')}
      it {should contain_file('/etc/kubernetes/config').with_content(/--master=http:\/\/1.1.1.1:8080"/)}
      it {should contain_file('/etc/sysconfig/flanneld').with_content(/FLANNEL_ETCD="http:\/\/1.1.1.1:4001"/)}
      ['kube-proxy','kubelet','docker','flanneld'].each do |i|
        it {should contain_service(i)}
      end
      ['docker','docker-logrotate','kubernetes','etcd', 'flannel'].each do |i|
        it {should contain_package(i)}
      end
    end
    describe 'with valid hostnames' do 
      let :params do {
        :master_name => 'master',
        :minion_name => 'minion'
      } end
      it {should compile}
    end

    describe 'with an array of valid minion ips' do 
      let :params do {
        :master_name => '1.1.1.1',
        :minion_name => ['1.2.1.1','1.3.1.1']
      } end
      it {should_not compile}
  end

  describe 'with a string minion_name' do
    let :params do {
        :master_name => '1.1.1.1',
        :minion_name => '1.2.1.1'
    } end
    it {should compile}
  end
  end
end



