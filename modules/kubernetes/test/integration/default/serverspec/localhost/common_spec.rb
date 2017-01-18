load 'test/serverspec_helper.rb'
['docker', 'docker-logrotate', 'kubernetes', 'etcd', 'flannel'].each do |package|
describe package(package), :if => os[:family] == 'redhat' do
    it { should be_installed }
end
end

