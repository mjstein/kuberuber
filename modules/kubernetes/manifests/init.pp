# Class: kubernetes
# ===========================
#
# mjs-Kubernetes enables the provisioning of Kubernetes clients and masters.
# Note that this has been tested on CentOS 7 which incidently has all the packages you need from epel
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example for master
#
#    class { 'kubernetes::master':
#      minion_name => [minion1.example.com,minion2.example.com],
#      master_name => master.example.com,
#    }
# @example for minion
#    class { 'kubernetes::minion':
#      minion_name => minion1.example.com,
#      master_name => master.example.com,
#    }
#
# Authors
# -------
#
# Michael Stein <msuddd@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2015 Michael Stein
#
class kubernetes($master_name, $minion_name, $populate_hosts = false){
    if $caller_module_name != $module_name {
      fail("Use of private class ${name} by ${caller_module_name}")
    }

}
