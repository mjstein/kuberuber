class { 'docker':
    package_name               => 'docker-1.10.3-59.el7.centos.x86_64', 
    extra_parameters           => "--insecure-registry 10.74.50.108:5000",
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
docker::image {'10.74.50.108:5000/ruby_app:2':
  docker_dir => '/root/kuberuber/plain_kuber/images/ruby_web/',
}
exec{'docker push 10.74.50.108:5000/ruby_app:2':
  refreshonly => true,
  path        => ['/bin'],
  require     =>  [Docker::Run['registry'],Docker::Image['10.74.50.108:5000/ruby_app:2']] ,
}
    class {'kubernetes::master':
      master_name                      => '10.74.50.108', #can be hostname if dns setup
      minion_name                      => '10.74.50.79', #can be hostname if dns setup
      master_is_minion                 => true,
      kubelet_args                     => "--cluster-dns=10.254.0.2 --cluster-domain=k8s.local",
      manage_docker                    => false,
    }
    contain 'kubernetes::master'


    # add in nfs mounts for volumes
    file{'/data_folder':
      ensure => directory,
      mode   =>  "0777",
    }
			class { '::nfs':
				server_enabled => true,
        client_enabled => true,
			}
			nfs::server::export{ '/data_folder':
				ensure  => 'mounted',
				clients => '*(rw,insecure,async,no_root_squash) localhost(rw)'
			}
      Nfs::Client::Mount <<| |>>

    exec{'kubectl create -f /root/kuberuber/plain_kuber/pods/dns/skydnssvc.yaml':
      path  => ['/bin'],
      require =>  Class['kubernetes::master']
    }
    exec{'kubectl create -f /root/kuberuber/plain_kuber/pods/dns/skydnsrc.yaml':
      path  => ['/bin'],
      require =>  Class['kubernetes::master']
    }

    exec{'kubectl create -f /root/kuberuber/plain_kuber/pods/ruby_web/ruby_web.yaml':
      path    => ['/bin'],
      require =>  [Class['kubernetes::master'],Exec['docker push 10.74.50.108:5000/ruby_app:2']]
    }

    exec{'kubectl create -f /root/kuberuber/plain_kuber/pods/ruby_web/ruby_web_service.yaml':
      path  => ['/bin'],
      require =>  [Class['kubernetes::master'],Exec['docker push 10.74.50.108:5000/ruby_app:2']]
    }

    exec{'kubectl create -f /root/kuberuber/plain_kuber/pods/dashboard/kubernetes-dashboard.yaml':
      path  => ['/bin'],
      require =>  Class['kubernetes::master'],
    }
