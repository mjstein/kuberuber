class { 'docker':
    package_name               => 'docker-1.10.3-59.el7.centos.x86_64', 
    extra_parameters           => "--insecure-registry 192.168.50.4:5000",
    service_overrides_template =>  false,
}
contain 'docker'
docker::image { 'registry:2':
}
docker::run { 'registry':
     image            => 'registry',
     extra_parameters => ['--restart=always'],
     ports            => ['5000:5000'],
}
docker::image {'192.168.50.4:5000/ruby_app:2':
  docker_dir => '/vagrant/plain_kuber/images/ruby_web/',
}~>
exec{'docker push 192.168.50.4:5000/ruby_app:2':
  refreshonly => true,
  path        => ['/bin'],
  require     =>  Docker::Run['registry'],
}
    class {'kubernetes::master':
      master_name                      => '192.168.50.4', #can be hostname if dns setup
      minion_name                      => '192.168.50.5', #can be hostname if dns setup
      master_is_minion                 => true,
      kubelet_args                     => "--cluster-dns=10.254.0.2 --cluster-domain=k8s.local",
      manage_docker                    => false,
      alternate_flannel_interface_bind => 'eth1'
    }
    contain 'kubernetes::master'

    exec{'kubectl create -f /vagrant/plain_kuber/pods/dns/skydnssvc.yaml':
      path  => ['/bin'],
      require =>  Class['kubernetes::master']
    }
    exec{'kubectl create -f /vagrant/plain_kuber/pods/dns/skydnsrc.yaml':
      path  => ['/bin'],
      require =>  Class['kubernetes::master']
    }

    exec{'kubectl create -f /vagrant/plain_kuber/pods/ruby_web/ruby_web.yaml':
      path    => ['/bin'],
      require =>  [Class['kubernetes::master'],Exec['docker push 192.168.50.4:5000/ruby_app:2']]
    }

    exec{'kubectl create -f /vagrant/plain_kuber/pods/ruby_web/ruby_web_service.yaml':
      path  => ['/bin'],
      require =>  [Class['kubernetes::master'],Exec['docker push 192.168.50.4:5000/ruby_app:2']]
    }

    exec{'kubectl create -f /vagrant/plain_kuber/pods/dashboard/kubernetes-dashboard.yaml':
      path  => ['/bin'],
      require =>  Class['kubernetes::master'],
    }
