class { 'etcd':
  ensure                     => 'latest',
  listen_client_urls    => 'http://0.0.0.0:2379',
}
etcd_key { '/atomic.io/network/config': value => '{ "Network": "10.100.5.0/24" }' }
class { 'kubernetes::master::apiserver':
  allow_privileged => true,
  service_cluster_ip_range => '10.100.5.0/24',
  etcd_servers => "http://127.0.0.1:2379",
  # etcd_prefix => '/atomic.io/network/config'
}
 class { 'kubernetes::master::scheduler':
  master => 'http://127.0.0.1:8080',
}
 class { 'kubernetes::node::kube_proxy':
  master => 'http://127.0.0.1:8080',
}

class { 'flannel':
  etcd_endpoints => "http://0.0.0.0:2379",
  etcd_prefix    => '/atomic.io/network/config',
}

