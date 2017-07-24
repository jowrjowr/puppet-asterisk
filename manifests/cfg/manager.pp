# Configure and asterisk manager
#
# $secret is the authentication password.
#
# $ensure can be set to absent to remove the manager.
#
# $deny is a list of IP specifications that are denied access to the manager.
#   Denied IPs can be overridden by $permit. This makes it possible to only
#   permit access to some IP addresses. Default value is to deny access to
#   everybody.
#
# $permit is a list of IP specifications that are permitted access to the
#   manager.
#
# $read is a list of authorizations given to the manager to read certain
#   information or configuration.
#
# $write is a list of authorizations given to the manager to write (change)
#   certain information or configuration.
#
define asterisk::cfg::manager (
  String $secret,
  Enum['present', 'absent'] $ensure   = present,
  Array $deny         = ['0.0.0.0/0.0.0.0'],
  Array $permit       = ['127.0.0.1/255.255.255.255'],
  Array $read         = ['system', 'call'],
  Array $write        = ['system', 'call']
) {

  $real_manager_name = $name
  $real_read = join($read, ',')
  $real_write = join($write, ',')

  asterisk::util::dotdfile {"manager_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'manager.d',
    content  => template('asterisk/snippet/manager.erb'),
    filename => "${name}.conf",
  }
}
