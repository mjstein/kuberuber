box = "centos/7"
Vagrant.configure("2") do |config|

  config.vm.define "kubcentral" do |web|
      web.vm.box = box 
      web.vm.network "private_network", ip: "192.168.50.4" #, auto_config: false
      web.vm.provider "virtualbox" do |v|
        v.memory =  8082
        v.cpus = 2
      end
      web.vm.provision "shell", path: "run.sh"
  end

  config.vm.define "w2" do |db|
    db.vm.box = box
      db.vm.network "private_network", ip: "192.168.50.5" #, auto_config: false
      db.vm.provision "shell", path: "run.sh"
  end
end
