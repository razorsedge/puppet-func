# == Class: func::params
#
# This class handles OS-specific configuration of the func module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class func::params {

### The following parameters should not need to be changed.

  $func_listen_addr = getvar('::func_listen_addr')
  if $func_listen_addr {
    $listen_addr = $::func_listen_addr
  } else {
    $listen_addr = '' # lint:ignore:empty_string_assignment
  }

  $func_puppetmaster_ssl_dir = getvar('::func_puppetmaster_ssl_dir')
  if $func_puppetmaster_ssl_dir {
    $puppetmaster_ssl_dir = $::func_puppetmaster_ssl_dir
  } else {
    $puppetmaster_ssl_dir = '/var/lib/puppet'
  }

  $func_use_puppet_certs = getvar('::func_use_puppet_certs')
  if $func_use_puppet_certs {
    $use_puppet_certs = $::func_use_puppet_certs
  } else {
    $use_puppet_certs = false
  }
  if is_string($use_puppet_certs) {
    $safe_use_puppet_certs = str2bool($use_puppet_certs)
  } else {
    $safe_use_puppet_certs = $use_puppet_certs
  }

  ######################################################################

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $func_ensure = getvar('::func_ensure')
  if $func_ensure {
    $ensure = $::func_ensure
  } else {
    $ensure = 'present'
  }

  $func_service_ensure = getvar('::func_service_ensure')
  if $func_service_ensure {
    $service_ensure = $::func_service_ensure
  } else {
    $service_ensure = 'running'
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $func_autoupgrade = getvar('::func_autoupgrade')
  if $func_autoupgrade {
    $autoupgrade = $::func_autoupgrade
  } else {
    $autoupgrade = false
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $func_service_enable = getvar('::func_service_enable')
  if $func_service_enable {
    $service_enable = $::func_service_enable
  } else {
    $service_enable = true
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $func_service_hasrestart = getvar('::func_service_hasrestart')
  if $func_service_hasrestart {
    $service_hasrestart = $::func_service_hasrestart
  } else {
    $service_hasrestart = true
  }
  if is_string($service_hasrestart) {
    $safe_service_hasrestart = str2bool($service_hasrestart)
  } else {
    $safe_service_hasrestart = $service_hasrestart
  }

  # RHEL func init script does not have a functioning status
  $func_service_hasstatus = getvar('::func_service_hasstatus')
  if $func_service_hasstatus {
    $service_hasstatus = $::func_service_hasstatus
  } else {
    $service_hasstatus = false
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
      $service_name       = 'funcd'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
