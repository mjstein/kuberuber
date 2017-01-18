ec2_instance { 'kubmaster':
  ensure            => present,
  region            => 'eu-west-1',
  subnet            => 'main',
  security_groups   => ['default'] ,
  image_id          => 'ami-7abd0209', # you need to select your own AMI
  key_name          => 'kubkey',
  instance_type     => 't2.medium',
  private_ip_address => '172.31.1.1',
  user_data         => template('aws_scripts/init.sh.erb'), 
}
ec2_instance { 'kubnode':
  ensure            => present,
  region            => 'eu-west-1',
  subnet            => 'main',
  security_groups   => ['default'] ,
  image_id          => 'ami-7abd0209', # you need to select your own AMI
  key_name          => 'kubkey',
  instance_type     => 't2.medium',
  private_ip_address => '172.31.1.2',
  user_data         => template('aws_scripts/init.sh.erb'), 
}
