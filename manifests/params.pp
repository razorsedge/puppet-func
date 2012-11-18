# == Class: func::params
#
# This class handles OS-specific configuration of the func module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class func::params {

### The following parameters should not need to be changed.

  $listen_addr = $::func_listen_addr ? {
    undef   => '',
    default => $::func_listen_addr,
  }

  $puppetmaster_ssl_dir = $::func_puppetmaster_ssl_dir ? {
    undef   => '/var/lib/puppet',
    default => $::func_puppetmaster_ssl_dir,
  }

  $use_puppet_certs = $::func_use_puppet_certs ? {
    undef   => false,
    default => $::func_use_puppet_certs,
  }
  if is_string($use_puppet_certs) {
    $safe_use_puppet_certs = str2bool($use_puppet_certs)
  } else {
    $safe_use_puppet_certs = $use_puppet_certs
  }

  ######################################################################

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $ensure = $::func_ensure ? {
    undef   => 'present',
    default => $::func_ensure,
  }

  $service_ensure = $::func_service_ensure ? {
    undef   => 'running',
    default => $::func_service_ensure,
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $autoupgrade = $::func_autoupgrade ? {
    undef   => false,
    default => $::func_autoupgrade,
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $service_enable = $::func_service_enable ? {
    undef   => true,
    default => $::func_service_enable,
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $service_hasrestart = $::func_service_hasrestart ? {
    undef   => true,
    default => $::func_service_hasrestart,
  }
  if is_string($service_hasrestart) {
    $safe_service_hasrestart = str2bool($service_hasrestart)
  } else {
    $safe_service_hasrestart = $service_hasrestart
  }

  # RHEL func init script does not have a functioning status
  $service_hasstatus = $::func_service_hasstatus ? {
    undef   => false,
    default => $::func_service_hasstatus,
  }
  if is_string($service_hasstatus) {
    $safe_service_hasstatus = str2bool($service_hasstatus)
  } else {
    $safe_service_hasstatus = $service_hasstatus
  }

  case $::osfamily {
    'RedHat': {
      $package_name       = 'func'
      $minion_file_name   = '/etc/func/minion.conf'
      $overlord_file_name = '/etc/func/overlord.conf'
      $group_file_name    = '/etc/func/groups'
      $service_name       = 'func'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
