Puppet Func Module
==================

master branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-func.png?branch=master)](http://travis-ci.org/razorsedge/puppet-func)
develop branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-func.png?branch=develop)](http://travis-ci.org/razorsedge/puppet-func)

Introduction
------------

This module manages the installation and configuration of [Func: Fedora Unified Network Controller](https://fedorahosted.org/func/).
Func allows for running commands on remote systems in a secure way, like SSH, but offers several improvements.

Actions:

* Installs the func package.
* Manages the overlord.conf and minion.conf files.
* Starts the func service.

OS Support:

* RedHat family - tested on CentOS 5.8+ and CentOS 6.3+
* Debian family - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.

Examples
--------

Top Scope variable (i.e. via Dashboard):

```Puppet
$certmaster_use_puppet_certs = true
$func_use_puppet_certs = true
# Change SSL dir for Puppet Enterprise.
$func_puppetmaster_ssl_dir = '/etc/puppetlabs/puppet'

include 'certmaster'
include 'func::minion'
```

Parameterized Class:

* minions

```Puppet
node default {
  class { 'certmaster':
    use_puppet_certs => true,
  }
  class { 'func::minion':
    use_puppet_certs => true,
  }
}
```

* overlord

```Puppet
node 'overlord.example.com' {
  class { 'certmaster':
    use_puppet_certs => true,
  }
  class { 'func::minion':
    use_puppet_certs => true,
  }
  class { 'func::overlord':
    use_puppet_certs => true,
  }
}
```

Notes
-----

* Requires the [razorsedge/cetmaster](https://github.com/razorsedge/puppet-certmaster) module even if using Puppet certificate authentication.
* Requires [EPEL](http://fedoraproject.org/wiki/EPEL) for RedHat family hosts.

Issues
------

* None

TODO
----

* Autopopulate the Func group file (possibly with exported resources?).
* Figure out how to negate the call to verify_contents in puppet-rspec tests in order to make sure that content is *missing* from a template.
* Add firewall support.
* Make the Puppet client determine $puppetmaster_ssl_dir.

Contributing
------------

Please see DEVELOP.md for contribution information.

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2012 Mike Arnold <mike@razorsedge.org>

