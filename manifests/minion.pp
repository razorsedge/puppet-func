# Class: func::minion
#
class func::minion (
  $listen_addr          = $func::params::listen_addr,
  $use_puppet_certs     = $func::params::use_puppet_certs,
  $puppetmaster_ssl_dir = $func::params::puppetmaster_ssl_dir,
  $ensure               = $func::params::ensure,
  $package_name         = $func::params::package_name,
  $file_name            = $func::params::minion_file_name,
  $service_ensure       = $func::params::service_ensure,
  $service_name         = $func::params::service_name,
  $service_enable       = $func::params::safe_service_enable,
  $service_hasrestart   = $func::params::safe_service_hasrestart,
  $service_hasstatus    = $func::params::service_hasstatus
) inherits func::params {
  # Validate our booleans
  validate_bool($service_enable)
  validate_bool($service_hasrestart)
  validate_bool($service_hasstatus)

  case $ensure {
    /(present)/: {
      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable_real = $service_enable
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
      $file_ensure = 'present'
    }
    /(absent)/: {
      $service_ensure_real = 'stopped'
      $service_enable_real = false
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  include func
  Class['func'] -> Class['func::minion']

  file { $file_name:
    ensure  => $file_ensure,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('func/minion.conf.erb'),
#    require => Package[$package_name],
    notify  => Service[$service_name],
  }

  service { $service_name :
    ensure     => $service_ensure_real,
    enable     => $service_enable_real,
    hasrestart => $service_hasrestart,
    hasstatus  => $service_hasstatus,
#    require    => Package[$package_name],
  }
}
