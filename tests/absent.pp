$certmaster_ensure = 'absent'
include certmaster
$func_ensure = 'absent'
include func::minion
include func::overlord
