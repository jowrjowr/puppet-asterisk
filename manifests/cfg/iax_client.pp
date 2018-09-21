# Configure an IAX2 client
# see: https://www.voip-info.org/asterisk-readme-iax
#
# $server is the hostname or IP of the server to which Asterisk should register.
#
# $user is the user name used for registering with the distant server.
#
# $password is the password used for registering.
#
# $ensure can be set to absent in order to remove the registry
#
define asterisk::cfg::iax_client (
  $type,
  $ensure = present,
  $context = 'default',
  $permit = undef,
  $deny = undef,
  $callerid = undef,
  $auth = undef,
  $secret = undef,
  $inkeys = undef,
  $allow = undef,
  $disallow = undef,
  $host = undef,
  $defaultip = undef,
) {

  $identifier = $name
  $user_vars = [ 'context', 'permit', 'deny', 'callerid', 'auth', 'secret', 'inkeys' ]
  $peer_vars = [ 'allow', 'disallow', 'host', 'defaultip' ]
  $friend_vars = $user_vars + $peer_vars
  asterisk::util::dotdfile { "client_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'iax.clients.d',
    content  => template('asterisk/registry/iax_client.erb'),
    filename => "${name}.conf",
  }

}
