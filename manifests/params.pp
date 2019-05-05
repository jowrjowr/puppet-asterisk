# Default values for the asterisk class
#
# This class is not intended to be used directly.
#
class asterisk::params {

  $manage_service = {
    'manage_service' => true,
    'service_name'   => $facts['os']['family'] ? {
      /(RedHat|Debian)/ => 'asterisk',
      default           => 'asterisk',
    },
  }

  $manage_package = {
    'manage_package'     => true,
    'package_name'       => $facts['os']['family'] ? {
      /(RedHat|Debian)/ => 'asterisk',
      default           => 'asterisk',
    },
    'manage_directories' => true,
    'manage_repos'       => 'all',
  }

  $confdir = '/etc/asterisk'

  $asterisk_runuser_grp = 'asterisk'
  $default_directory_perm = '0644'
  $asterisk_options = {
    'directories' => {
      'astetcdir'    => $confdir,
      'astmoddir'    => '/usr/lib/asterisk/modules',
      'astvarlibdir' => '/var/lib/asterisk',
      'astdbdir'     => '/var/lib/asterisk',
      'astkeydir'    => '/var/lib/asterisk',
      'astdatadir'   => '/var/lib/asterisk',
      'astagidir'    => '/var/lib/asterisk/agi-bin',
      'astspooldir'  => '/var/spool/asterisk',
      'astrundir'    => '/var/run/asterisk',
      'astlogdir'    => '/var/log/asterisk',
      'astsbindir'   => '/usr/sbin',
    },
    'options'     => {
      'timestamp'                      => true,
      'highpriority'                   => true,
      'dumpcore'                       => true,
      'transmit_silence_during_record' => true,
      'transmit_silence'               => true,
      'runuser'                        => $asterisk_runuser_grp,
      'rungroup'                       => $asterisk_runuser_grp,
      'documentation_language'         => 'en_US',
      'hideconnect'                    => true,
    },
    'files'       => {
      'astctlpermissions' => '0660',
      'astctlowner'       => $asterisk_runuser_grp,
      'astctlgroup'       => $asterisk_runuser_grp,
      'astctl'            => 'asterisk.ctl',
    },
  }

  $iax_options = {
    'general' => {
      'allow'             => [],
      'disallow'          => ['lpc10'],
      'bandwidth'         => 'low',
      'jitterbuffer'      => false,
      'forcejitterbuffer' => false,
      'autokill'          => true,
      # Some added security default options
      'delayreject'       => true,
    },
  }

  $sip_options = {
    'general' => {
      'disallow'         => [],
      'allow'            => [],
      'domain'           => [],
      'localnet'         => [],
      'context'          => 'default',
      'allowoverlap'     => false,
      'udpbindaddr'      => '0.0.0.0',
      'tcpenable'        => false,
      'tcpbindaddr'      => '0.0.0.0',
      'transport'        => 'udp',
      'srvlookup'        => true,
      # Some added security default options
      'allowguest'       => false,
      'alwaysauthreject' => true,
    },
  }

  $voicemail_options = {
    'general' => {
      'format'           => 'wav|gsm|wav',
      'serveremail'      => 'asterisk',
      'attach'           => true,
      'skipms'           => 3000,
      'maxsilence'       => 10,
      'silencethreshold' => 128,
      'maxlogins'        => 3,
      'emaildateformat'  => '%A, %B %d, %Y at %r',
      'pagerdateformat'  => '%A, %B %d, %Y at %r',
      'sendvoicemail'    => true,
    },
  }

  $extensions_options = {
    'general' => {
      'static'          => true,
      'writeprotect'    => false,
      'clearglobalvars' => false,
      'priorityjumping' => false,
    },
  }

  $agents_config = {
    'multiplelogin' => true,
    'options'       => {},
  }

  # defines the default parkinglot
  $features_config = {
    'general'    => {},
    'parking'    => {
      'parkeddynamic' => true,
    },
    'featuremap' => {},
  }


  $queues_options = {
    'general' => {
      'persistentmembers' => true,
      'monitor-type'      => 'MixMonitor',
    },
  }

  $modules_config = {
    'autoload' => true,
    'load'     => [
      'res_musiconhold.so',
    ],
    'noload'   => [
      # those modules are disabled, since we currently don't provide
      # any useful configuration
      'res_snmp.so',
      'res_smdi.so',
      'app_confbridge.so',
      'res_phoneprov.so',
      'pbx_gtkconsole.so',
      'pbx_kdeconsole.so',
      'app_intercom.so',
      'chan_modem.so',
      'chan_modem_aopen.so',
      'chan_modem_bestdata.so',
      'chan_modem_i4l.so',
      'chan_capi.so',
      'chan_alsa.so',
      'cdr_sqlite.so',
      'app_directory_odbc.so',
      'res_config_pgsql.so',
    ],
    'preload'  => [],
  }

  #
  # define which configs need to be absent if the corresponding module is on the "noload" list
  $absent_configs_on_noload_modules = {
    'app_alarmreceiver.so' => ['alarmreceiver.conf'],
    'res_config_pgsql.so'  => ['res_config_pgsql.conf'],
    'app_amd.so'           => ['amd.conf'],
    'cdr_sqlite.so'        => ['cdr_sqlite.conf'],
    'pbx_dundi.so'         => ['dundi.conf'],
    'app_confbridge.so'    => ['confbridge.conf'],
    'app_followme.so'      => ['followme.conf'],
    'res_phoneprov.so'     => ['phoneprov.conf'],
    'res_snmp.so'          => ['res_snmp.conf'],
    'res_smdi.so'          => ['smdi.conf'],
  }

  # like asterisk modules we don't load (noload) because this module
  # does not provide any good configuration logic for them, these
  # files are held absent, to force asterisk to use default values
  $unused_files = [
    'vpb.conf',
    'users.conf',
    'dsp.conf',
    'iaxprov.conf',
    'muted.conf',
    'osp.conf',
    'sla.conf',
    'ss7.timers',
    'telcordia-1.adsi',
    'ccss.conf',
  ]

  $manager_config = {
    'general' => {
      'enabled'  => true,
      'port'     => 5038,
      'bindaddr' => '127.0.0.1',
    },
  }

  $realtime_options = {
    'sipusers' => {
      'driver'   => 'mysql',
      'database' => 'general',
      'table'    => 'sipfriends',
    },
    'sippeers' => {
      'driver'   => 'mysql',
      'database' => 'general',
      'table'    => 'sipfriends',
    },
  }

  $logger_options = {
    'general'  => {
      'queue_log'      => true,
      'event_log'      => true,
      'dateformat'     => '%F %T.%3q',
      'appendhostname' => true,
      'rotatestrategy' => 'timestamp',
    },
    'logfiles' => {
      'debug'    => 'debug',
      'console'  => 'notice,warning,error',
      'messages' => 'notice,warning,error',
      'full'     => 'notice,warning,error,debug,verbose',
    },
  }

  # lint:ignore:single_quote_string_with_variables
  $cdr_config = {
    'general'                => {
      'enable'          => true,
      'unanswered'      => true,
      'congestion'      => true,
      'endbeforehexten' => false,
      'batch'           => false,
      'safeshutdown'    => true,
    },
    'backends'               => {
      'csv' => {
        'usegmtime'     => true,
        'loguniqueid'   => true,
        'loguserfield'  => true,
        'accountlogs'   => true,
        'newcdrcolumns' => true,
      },
    },
    'mappings'               => {
      'Master.csv' => [
        '${CSV_QUOTE(${CDR(clid)})}',
        '${CSV_QUOTE(${CDR(src)})}',
        '${CSV_QUOTE(${CDR(dst)})}',
        '${CSV_QUOTE(${CDR(dcontext)})}',
        '${CSV_QUOTE(${CDR(channel)})}',
        '${CSV_QUOTE(${CDR(dstchannel)})}',
        '${CSV_QUOTE(${CDR(lastapp)})}',
        '${CSV_QUOTE(${CDR(lastdata)})}',
        '${CSV_QUOTE(${CDR(start)})}',
        '${CSV_QUOTE(${CDR(answer)})}',
        '${CSV_QUOTE(${CDR(end)})}',
        '${CSV_QUOTE(${CDR(duration,f)})}',
        '${CSV_QUOTE(${CDR(billsec,f)})}',
        '${CSV_QUOTE(${CDR(disposition)})}',
        '${CSV_QUOTE(${CDR(amaflags)})}',
        '${CSV_QUOTE(${CDR(accountcode)})}',
        '${CSV_QUOTE(${CDR(uniqueid)})}',
        '${CSV_QUOTE(${CDR(userfield)})}',
        '${CDR(sequence)}',
      ],
      'Simple.csv' => [
        '${CSV_QUOTE(${EPOCH})}',
        '${CSV_QUOTE(${CDR(src)})}',
        '${CSV_QUOTE(${CDR(dst)})}',
      ],
    },
    'manager'                => {
      'general'  => {
        'enabled' => false,
      },
      'mappings' => {},
    },
    'backend_special_config' => {
      'cdr_mysql' => {
        'enable' => false,
        'config' => {
          'global'  => {
            'user'     => 'asterisk',
            'password' => '',
            'hostname' => '127.0.0.1',
            'dbname'   => 'asterisk',
            'table'    => 'cdr',
            'charset'  => 'utf8',
          },
          'columns' => {},
        },
      },
    },
  }
  # lint:endignore

  $res_config_mysql_config = {
    'enable'      => false,
    'connections' => {
      'general' => {
        'dbhost'       => '127.0.0.1',
        'dbname'       => 'asterisk',
        'dbuser'       => '',
        'dbpass'       => 'asterisk',
        'dbcharset'    => 'utf8',
        'requirements' => 'createclose',
      },
    },
  }

  $meetme_config = {
    'general' => {
      'audiobuffers'   => 32,
      'logmembercount' => true,
    },
  }

  $ari_config = {
    'general' => {
      'enabled' => false,
    },
  }

  $sip_notifies = {
    'snom-check-cfg' => {
      'Event' => 'check-sync\;reboot=false',
    },
    'snom-reboot'    => {
      'Event' => 'check-sync\;reboot=true',
    },
  }

  $cel_config = {
    'general' => {
      'enable' => false,
      'events' => [
        'APP_START',
        'CHAN_START',
        'CHAN_END',
        'ANSWER',
        'HANGUP',
        'BRIDGE_ENTER',
        'BRIDGE_EXIT',
      ],
    },
    'manager' => {
      'enabled' => false,
    },
  }

  $cel_config_mappings = {
    'mappings' => $cdr_config['mappings']['Master.csv'],
  }

  $chan_dahdi_config = {
    'enabled' => false,
    'global'  => {
      'language'              => 'de',
      'pridialplan'           => 'local',
      'prilocaldialplan'      => 'local',
      'resetinterval'         => 3600,
      'overlapdial'           => true,
      'inbanddisconnect'      => true,
      'priindication'         => 'outofband',
      'rxwink'                => 300,
      'usecallerid'           => true,
      'hidecallerid'          => false,
      'callwaiting'           => true,
      'usecallingpres'        => true,
      'callwaitingcallerid'   => true,
      'threewaycalling'       => true,
      'transfer'              => true,
      'canpark'               => true,
      'cancallforward'        => true,
      'callreturn'            => true,
      'busydetect'            => true,
      'echocancel'            => true,
      'echocancelwhenbridged' => true,
      'faxdetect'             => 'incoming',
      'relaxdtmf'             => true,
      'rxgain'                => '0.0',
      'txgain'                => '0.0',
      'callgroup'             => '1',
      'pickupgroup'           => '1',
      'immediate'             => false,
      'jitterbuffers'         => 4,
      'jbenable '             => true,
      'internationalprefix '  => '+',
      'nationalprefix'        => '+49',
    },
    'groups'  => {},
  }

  $cli_config = {
    'startup_commands' => {
      'core set verbose 3' => true,
      'core set debug 1'   => true,
    },
  }

  $cli_config_permissions = {
    'general'  => {
      'default_perm' => false,
    },
    'root'     => {
      'permit' => 'all',
    },
    'asterisk' => {
      'permit' => 'all',
    },
  }

  $dnsmgr_config = {
    'general' => {
      'enable'          => false,
      'refreshinterval' => 1200,
    },
  }

  $enum_config = {
    'search'     => ['e164.arpa'],
    'h323driver' => ['H323'],
  }

  $http_config = {
    'general' => {
      'enabled' => false,
    },
  }

  $moh_config = {
    'general' => {
      'cachertclasses' => false,
    },
    'default' => {},
  }

  $stun_config = {
    'enabled' => false,
  }

  $rtp_config = {
    'general'             => {
      'rtpstart'     => 10000,
      'rtpend'       => 20000,
      'rtpchecksums' => false,
      'dtmftimeout'  => 3000,
      'rtcpinterval' => 5000,
      'strictrtp'    => true,
      'probation'    => 4,
      'icesupport'   => false,
    },
    'ice_host_candidates' => {},
    'udptl'               => {
      'udptlstart'      => 4000,
      'udptlend'        => 4999,
      'udptlchecksums'  => false,
      'udptlfecentries' => 3,
      'udptlfecspan'    => 3,
      'use_even_ports'  => false,
    },
  }

  $stasis_config = {
    'threadpool'             => {
      'initial_size'     => 5,
      'idle_timeout_sec' => 20,
      'max_size'         => 50,
    },
    'declined_message_types' => {},
  }

  $statsd_config = {
    'general' => {
      'enabled'     => false,
      'server'      => '127.0.0.1',
      'prefix'      => '',
      'add_newline' => false,
    },
  }

  $festival_config = {
    'general' => {},
  }

  $amd_config = {
    'general' => {},
  }

  $codecs_config = {
    'speex'   => {
      'quality'           => '3',
      'complexity'        => '2',
      'enhancement'       => 'true',
      'vad'               => 'true',
      'vbr'               => 'true',
      'abr'               => '0',
      'vbr_quality'       => '4',
      'dtx'               => 'false',
      'preprocess'        => 'false',
      'pp_vad'            => 'false',
      'pp_agc'            => 'false',
      'pp_agc_level'      => '8000',
      'pp_denoise'        => 'false',
      'pp_dereverb'       => 'false',
      'pp_dereverb_decay' => '0.4',
      'pp_dereverb_level' => '0.3',
    },
    'plc'   => {
      'genericplc'        => 'true',
    },
    'silk8' => {
      'type'                  => 'silk',
      'samprate'              => '8000',
      'fec'                   => 'true',
      'packetloss_percentage' => '10',
      'maxbitrate'            => '10000',
    },
    'silk12' => {
      'type'                  => 'silk',
      'samprate'              => '12000',
      'maxbitrate'            => '12000',
      'fec'                   => 'true',
      'packetloss_percentage' => '10',
    },
    'silk16' => {
      'type'                  => 'silk',
      'samprate'              => '16000',
      'maxbitrate'            => '20000',
      'fec'                   => 'true',
      'packetloss_percentage' => '10',
    },
    'silk24' => {
      'type'                  => 'silk',
      'samprate'              => '24000',
      'maxbitrate'            => '30000',
      'fec'                   => 'true',
      'packetloss_percentage' => '10',
    },
  }

  # leaving empty structure for pjsip config for future use
  # the sample config is empty so no configuration defaults
  $pjsip_config = {
    'general'             => {},
    'system'              => {},
    'global'              => {},
    'transport-tcp'       => {},
    'transport-udp'       => {},
    'transport-tls'       => {},
  }
  $pjsip_notify_config = {
    'clear-mwi' => {
      'Event'         => 'message-summary',
      'Content-type'  => 'application/simple-message-summary',
      'Content'       => 'Messages-Waiting: no',
      'Content '      => 'Message-Account: sip:asterisk@127.0.0.1',
      'Content  '      => 'Voice-Message: 0/0 (0/0)',
    },
    'aastra-check-cfg' => {
      'Event'         => 'check-sync'
    },
    'aastra-xml' => {
      'Event'         => 'aastra-xml'
    },
    'digium-check-cfg' => {
      'Event'         => 'check-sync'
    },
    'linksys-cold-restart' => {
      'Event'         => 'reboot_now'
    },
    'linksys-warm-restart' => {
      'Event'         => 'restart_now'
    },
    'polycom-check-cfg' => {
      'Event'         => 'check-sync'
    },
    'sipura-check-cfg' => {
      'Event'         => 'resync'
    },
    'sipura-get-report' => {
      'Event'         => 'report'
    },
    'snom-check-cfg' => {
      'Event'         => 'check-sync\;reboot=false'
    },
    'snom-reboot' => {
      'Event'         => 'check-sync\;reboot=true'
    },
    'cisco-check-cfg' => {
      'Event'         => 'check-sync'
    },
  }

  $app_mysql_config = {
    'general' => {
        'nullvalue'     => 'nullstring',
        'autoclear'     => 'yes',
    },
  }

  $res_odbc_config = {
    'ENV'   => {
      'INFORMIXSERVER'  => 'my_special_database',
      'INFORMIXDIR'     => '/opt/informix',
    },
    'asterisk'  => {
      'enabled'         => 'no',
      'dsn'             => 'asterisk',
    }
  }
}
