
define kubernetes::core($master_name, $minion_name, $master_is_minion=false, $alternate_flannel_interface_bind =false, $manage_docker = true ){
  if $manage_docker {
    package {'docker':
      ensure => present,
    }
  }
  package {[ 'docker-logrotate', 'kubernetes', 'etcd', 'flannel']:
    ensure => present,
  }

  file{'/etc/kubernetes/config':
    content => template('kubernetes/kub_config.erb'),
    require => Package['kubernetes'],
    notify  =>  Service['flanneld'],
  }
  file{'/etc/sysconfig/flanneld':
    content => template('kubernetes/flanneld.erb'),
    require => Package['flannel'],
    notify  =>  Service['flanneld'],
  }
  service{'flanneld':
    ensure => running,
    enable => true,
    notify =>  Service['docker'],
  }
  if $manage_docker {
    service{'docker':
      ensure  => running,
      enable  => true,
      require =>  Package['docker']
    }
  }
}
