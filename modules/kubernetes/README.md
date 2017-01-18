# kubernetes

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with kubernetes](#setup)
    * [What kubernetes affects](#what-kubernetes-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kubernetes](#beginning-with-kubernetes)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module at present install a kubernetes master and minion. it is still heavily in development as at present should only be used on CentOS 7 unless one wishes to add their own repos

## Module Description
Will add a basic minion/master on a series of CentOS 7 Boxes

## Setup
Example master setup
```
node 'master'{

    class {'kubernetes::master':
      master_name => '173.16.32.11', #can be hostname if dns setup
      minion_name => ['173.16.32.12','173.16.32.12'], #can be hostname if dns setup
    }
    contain 'kubernetes'
}
```
Example minion setup
```
node 'minion'{

    class {'kubernetes::minion':
      master_name => '173.16.32.11', #can be hostname if dns setup
      minion_name => '173.16.32.12', #can be hostname if dns setup
    }
    contain 'kubernetes'
}
```
These values can also be specified in hiera

For a master
```
---
  kubernetes::master_name: '173.16.32.11'
  kubernetes::minion_name:  ['173.16.32.12']
```
For minions
```
---
  kubernetes::master_name: '173.16.32.11'
  kubernetes::minion_name:  '173.16.32.12'
```

### What kubernetes affects
kubernetes will install a kube master if kubernetes::master class is called, else it will add a minion if kubernetes::minion is called

### Setup Requirements **OPTIONAL**
Be sure epel is enabled, if you do not have epel you will need to `yum install epel-release`
none as yet but std lib will be needed soon
### Beginning with kubernetes

I have tested this on CentOS 7 since epel has all of the rpms you will need (once epel is enabled), no additional packages should be needed. As yet I have not tied down the ordering , this will follow.
## Usage
Example master setup
```
node 'master'{

    class {'kubernetes::master':
      master_name => '173.16.32.11', #can be hostname if dns setup
      minion_name => ['173.16.32.12','173.16.32.12'], #can be hostname if dns setup
    }
    contain 'kubernetes'
}
```
Example minion setup
```
node 'minion'{

    class {'kubernetes::minion':
      master_name => '173.16.32.11', #can be hostname if dns setup
      minion_name => '173.16.32.12', #can be hostname if dns setup
    }
    contain 'kubernetes'
}
```

## Reference
classes as follows:
```
kubernetes
kubernetes::master
kubernetes::minion
```
## Limitations

This should not be considered a production release it is far too young and undeveloped. Nonetheless it can be used as a guide. I would suggest testing this with vagrant.

## Development

I welcome any input since we have very few kubernetes modules

