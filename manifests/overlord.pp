# Class: func::overlord
#
class func::overlord (
  $use_puppet_certs     = $func::params::use_puppet_certs,
  $puppetmaster_ssl_dir = $func::params::puppetmaster_ssl_dir,
  $ensure               = $func::params::ensure,
  $file_name            = $func::params::overlord_file_name,
  $group_file_name      = $func::params::group_file_name
) inherits func::params {

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
