# Configure an asterisk queue
#
# This resource presents a multitude of options, corresponding to different
# options that can be configured for queues. The README file presents links to
# resources that describe what all of the options do.
#
# One parameter is an exception:
#
# $ensure can be set to absent in order to remove a queue
#
define asterisk::cfg::queue (
  Enum['present', 'absent'] $ensure   = present,
  Boolean $strategy = false,
  Array $members = [],
  Integer $memberdelay = false,
  Integer $penaltymemberslimit = false,
  Variant[Boolean, String] $membermacro = false,
  Variant[Boolean, String] $membergosub = false,
  Variant[Boolean, String] $context = false,
  Variant[Boolean, String] $defaultrule = false,
  Variant[Boolean, Integer] $maxlen = false,
  Variant[Boolean, String] $musicclass = false,
  Variant[Boolean, String] $servicelevel = false,
  Variant[Boolean, Integer] $weight = false,
  Array $joinempty = [],
  Array $leavewhenempty = [],
  Boolean $eventwhencalled = false,
  Boolean $eventmemberstatus = false,
  Boolean $reportholdtime = false,
  Boolean $ringinuse = false,
  Boolean $monitor_type = false,
  Array[String] $monitor_format = [],
  Boolean $announce = false,
  Boolean $announce_frequency = false,
  Boolean $min_announce_frequency = false,
  Boolean $announce_holdtime = false,
  Boolean $announce_position = false,
  Boolean $announce_position_limit = false,
  Boolean $announce_round_seconds = false,
  Array[String] $periodic_announce = [],
  Integer $periodic_announce_frequency = false,
  String $random_periodic_announce = false,
  String $relative_periodic_announce = false,
  String $queue_youarenext = false,
  String $queue_thereare = false,
  String $queue_callswaiting = false,
  Integer $queue_holdtime = false,
  String $queue_minute = false,
  String $queue_minutes = false,
  Boolean $queue_seconds = false,
  Boolean $queue_thankyou = false,
  Boolean $queue_reporthold = false,
  Integer $wrapuptime = false,
  Integer $timeout = false,
  Integer $timeoutrestart = false,
  Integer $timeoutpriority = false,
  Integer $retry = false,
  Boolean $autofill = false,
  Boolean $autopause = false,
  Boolean $setinterfacevar = false,
  Boolean $setqueuevar = false,
  Boolean $setqueueentryvar = false
) {

  # Ensure that we can iterate over some of the parameters.
  validate_array($members)
  validate_array($joinempty)
  validate_array($leavewhenempty)
  validate_array($monitor_format)
  validate_array($periodic_announce)

  asterisk::util::dotdfile {"queue_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'queues.d',
    content  => template('asterisk/snippet/queue.erb'),
    filename => "${name}.conf",
  }

}
