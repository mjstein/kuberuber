load 'test/serverspec_helper.rb'

['etcd', 'kube-apiserver', 'kube-controller-manager', 'kube-scheduler','docker','flanneld'].each do |service|
  describe service(service), :if => os[:family] == 'redhat' do
    it { should be_enabled }
    it { should be_running }
  end
end 

describe command('curl -L http://localhost:4001/v2/keys/flannel/network') do 
    its(:stdout) { should match /"key":"\/flannel\/network\/config"/ }
end

describe command('kubectl get nodes') do 
    its(:stdout) { should match /kubernetes.io\/hostname/ }
end
