class kubernetes::hosts($populate_hosts = false){
  if $populate_hosts {
    host{$kubernetes::master_name:
      ip => $kubernetes::master_ip
    }
    host{$kubernetes::minion_name:
      ip => $kubernetes::minion_ip
    }
  }
}
