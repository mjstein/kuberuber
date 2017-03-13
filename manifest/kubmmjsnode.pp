class { 'docker':
    package_name => 'docker-1.10.3-59.el7.centos.x86_64', 
    extra_parameters => "--insecure-registry 192.168.50.4:5000",
    service_overrides_template =>  false,
}
    class {'kubernetes::minion':
       master_name                      => '192.168.50.4', #can be hostname if dns setup
       minion_name                      => '192.168.50.5', #can be hostname if dns setup
       manage_docker                    => false,
       alternate_flannel_interface_bind =>  'eth1',
      kubelet_args                     => "--cluster-dns=10.254.0.2 --cluster-domain=k8s.local",
    }
    contain 'kubernetes'
    # mount nfs mounts
      class { '::nfs':
        client_enabled =>  true,
      }
      nfs::client::mount { '/data_folder':
        server =>  '192.168.50.4',
      }
