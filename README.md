FUNC Module
===========

master branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-func.png?branch=master)](http://travis-ci.org/razorsedge/puppet-func)
develop branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-func.png?branch=develop)](http://travis-ci.org/razorsedge/puppet-func)

Introduction
------------

This module manages the installation and configuration of [FUNC](https://fedorahosted.org/func/).
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

    # Top Scope variable (i.e. via Dashboard):
    $func_use_puppet_certs = true
    $func_puppetmaster_ssl_dir = '/etc/puppetlabs/puppet'
    include 'func::minion'


    # Parameterized Class:
    # minions
    node default {
      class { 'func::minion':
        use_puppet_certs => true,
      }
    }

    # overlord
    node 'overlord.example.com' {
      class { 'func::minion':
        use_puppet_certs => true,
      }
      class { 'func::overlord':
        use_puppet_certs => true,
      }
    }


Notes
-----

* Requires the razorsedge/cetmaster module even if using Puppet certificate authentication.

Issues
------

* None

TODO
----

* None

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2012 Mike Arnold <mike@razorsedge.org>

