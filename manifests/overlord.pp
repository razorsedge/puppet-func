# == Class: func::overlord
#
# This module handles configuring a func overlord.  This module requires
# func version 0.27 or newer and can configure func to use puppet certificates.
#
# === Parameters:
#
# [*use_puppet_certs*]
#   Whether to use existing Puppet certificates or use Certmaster.
#   Default: false
#
# [*puppetmaster_ssl_dir*]
#   Directory in which to locate Puppet SSL certificates.
#   Default: /var/lib/puppet
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*file_name*]
#   Name of the overlord config file.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*group_file_name*]
#   Name of the group config file.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# === Actions:
#
# Configures the func overlord.conf.
#
# === Sample Usage:
#
#   class { 'func::overlord':
#     use_puppet_certs => true,
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
class func::overlord (
  $use_puppet_certs     = $func::params::safe_use_puppet_certs,
  $puppetmaster_ssl_dir = $func::params::puppetmaster_ssl_dir,
  $ensure               = $func::params::ensure,
  $file_name            = $func::params::overlord_file_name,
  $group_file_name      = $func::params::group_file_name
) inherits func::params {
  # Validate our booleans
  validate_bool($use_puppet_certs)

  case $ensure {
    /(present)/: {
      $file_ensure = 'present'
    }
    /(absent)/: {
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  include func
  Class['func'] -> Class['func::overlord']

  file { $group_file_name :
    ensure  => $file_ensure,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    # TODO: autopopulate the func group file.
    #source  => 'puppet:///modules/func/group',
#    require => Package[$package_name],
  }

  file { $file_name :
    ensure  => $file_ensure,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('func/overlord.conf.erb'),
#    require => Package[$package_name],
  }
}
