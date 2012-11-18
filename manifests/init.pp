# == Class: func
#
# This module handles installing func.  To configure as a minion and/or
# overlord, include func::minion and/or func::overlord.  This module requires
# func version 0.27 or newer and can configure func to use puppet certificates.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*package_name*]
#   Name of the package.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# === Actions:
#
# Installs the func package.
#
# === Sample Usage:
#
#   class { 'func':
#     autoupgrade => true,
#   }
#
# === Authors
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class func (
  $ensure       = $func::params::ensure,
  $autoupgrade  = $func::params::safe_autoupgrade,
  $package_name = $func::params::package_name
) inherits func::params {
  # Validate our booleans
  validate_bool($autoupgrade)

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }
    }
    /(absent)/: {
      $package_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

#  require smolt
  include certmaster
  Class['certmaster'] -> Class['func']

  package { $package_name :
    ensure  => $package_ensure,
  }

  # Use this to fix upgrades from our previous func module which deployed a
  # custom /etc/logrotate.d/func_rotate.
#  exec { 'func_rotate.rpmnew':
#    command => 'mv /etc/logrotate.d/func_rotate.rpmnew /etc/logrotate.d/func_rotate',
#    path    => '/bin:/usr/bin:/usr/local/bin',
#    onlyif  => 'test -f /etc/logrotate.d/func_rotate.rpmnew',
#    require => Package[$package_name],
#  }
}
