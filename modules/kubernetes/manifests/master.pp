class kubernetes::master($master_name = undef, $minion_name = undef,$alternate_flannel_interface_bind = false, $master_is_minion = false, $manage_docker = false, $kubelet_args = "") {
  validate_string($master_name)
  validate_string($minion_name)
  unless defined(Class['kubernetes']){
    class {'kubernetes':
      master_name =>  $master_name,
      minion_name =>  $minion_name,
      before      =>  Kubernetes::Core['master_core']
    }
  }
  unless defined(Kubernetes::Core['minion_core']){
    kubernetes::core{'master_core':
      master_name                      => $master_name,
      minion_name                      => $minion_name,
      master_is_minion                 => $master_is_minion,
      alternate_flannel_interface_bind => $alternate_flannel_interface_bind,
      manage_docker                    =>  $manage_docker,
    }
  }
  file{'/etc/kubernetes/apiserver':
    content => template('kubernetes/apiserver.erb'),
    notify  => Service['kube-apiserver'],
    require => Package['kubernetes'],
  }
  file{'/etc/kubernetes/controller-manager':
    content => template('kubernetes/controller.erb'),
    require =>  Package['kubernetes'],
    notify  =>  Service['kube-controller-manager'],
  }

  file{'/etc/etcd/etcd.conf':
    ensure  => present,
    source  => 'puppet:///modules/kubernetes/etcd_config',
    require => Package['etcd'],
    notify  => Service['etcd'],
  }


  service{'etcd':
    ensure  => running,
    enable  => true,
  }
  service{[ 'kube-apiserver', 'kube-controller-manager', 'kube-scheduler']:
    ensure  => running,
    enable  => true,
    require =>  [Package['kubernetes'],Service['etcd']]
  }

  file{'/tmp/flannel-config.json':
    ensure => present,
    source => 'puppet:///modules/kubernetes/flannel-config',
  }->

  exec{'populate etcd server':
    path    => ['/bin'],
    command => "curl -L http://${::kubernetes::master_name}:4001/v2/keys/flannel/network/config -XPUT --data-urlencode value@/tmp/flannel-config.json",
    unless  => 'curl -L http://localhost:4001/v2/keys/flannel/network/config;if [ $? -eq 0 ]; then return 1; else return 0;fi', 
    require => Service['etcd'],
  }

  if $master_is_minion {
    class{'kubernetes::minion':
      master_name      => $master_name, #can be hostname if dns setup
      minion_name      => $minion_name, #can be hostname if dns setup
      master_is_minion => $master_is_minion,
      kubelet_args     =>  $kubelet_args,
    }

    }
  
}
