class { 'certmaster':
  ensure => 'absent',
}
class { 'func::minion':
  ensure => 'absent',
}
class { 'func::overlord':
  ensure => 'absent',
}
