# Asterisk class
#
# @summary Install and configure an asterisk server
# @example To install Asterisk on a server, simply use the following:
#   include asterisk
#
# @param manage_service Defines if the service should be managed, what the service name should be and optionally if a seperate restart command should be used
# @param manage_package Defines if the package should be managed and what the package name is.
# @param confdir Defines where this module will generate the configuration in
# @param asterisk_options Defines the contents of asterisk.conf
# @param iax_options Defines the 'general' contents of iax.conf. Manage registry/users trough asterisk::cfg:iax/asterisk::cfg:iax_registry
# @param sip_options Defines the 'general' contents of sip.conf. Manage registry/users trough asterisk::cfg:sip/asterisk::cfg:sip_registry
# @param sip_notifies Define sip_notfies (sip_notifies.conf) by '<notify_name> => {'<Header>' => '<value>', ..}
# @param voicemail_options Defines the 'general' contents of voicemail.conf. Manage single voicemails through asterisk::cfg:voicemail
# @param extensions_options Defines the 'general' contents of sip.conf.  Manage single voicemails through asterisk::cfg:extension
# @param features_config Defines the 'general' contents
#

class asterisk (
  Struct[{
    'manage_service'          => Boolean,
    'service_name'            => Optional[String],
    'service_restart_command' => Optional[String],
  }] $manage_service                             = $asterisk::params::manage_service,
  Struct[{
    'manage_package'     => Optional[Boolean],
    'package_name'       => Optional[String],
    'manage_directories' => Optional[Boolean],
    'manage_repos'       => Optional[Enum['all', 'only-asterisk', 'none']],
  }] $manage_package                             = $asterisk::params::manage_package,
  Stdlib::Absolutepath $confdir                  = $asterisk::params::confdir,
  Struct[{
    'directories' => Hash[String, NotUndef],
    'options'     => Hash[String, NotUndef],
    'files'       => Hash[String, NotUndef],
  }]  $asterisk_options                          = $asterisk::params::asterisk_options,
  Struct[{
    'general' => Hash[String, NotUndef]
  }] $iax_options                                = $asterisk::params::iax_options,
  Struct[{
    'general' => Hash[String, NotUndef]
  }] $sip_options                                = $asterisk::params::sip_options,
  Hash[
    String,
    Hash[String, NotUndef]
  ] $sip_notifies                                = $asterisk::params::sip_notifies,
  Struct[{
    'general' => Hash[String, NotUndef],
    'zonemessages' => Optional[Hash[String, NotUndef]],
    'default' => Optional[Hash[String, NotUndef]],
  }]  $voicemail_options                         = $asterisk::params::voicemail_options,
  Struct[{
    'general' => Hash[String, NotUndef],
    'globals' => Optional[Hash[String, NotUndef]],

  }]  $extensions_options                        = $asterisk::params::extensions_options,
  Struct[{
    'general'      => Optional[Hash[String, NotUndef]],
    'featuremap'   => Hash[String, NotUndef],
  }] $features_config                            = $asterisk::params::features_config,
  Struct[{
    'general'      => Hash[String, NotUndef],
    'default'      => Optional[Hash[String, NotUndef]],
  }] $parking_config                            = $asterisk::params::parking_config,
  Struct[{
    'general' => Hash[String, NotUndef],
  }] $queues_options                             = $asterisk::params::queues_options,
  Struct[{
    'autoload' => Boolean,
    'noload'   => Optional[Array],
    'load'     => Optional[Array],
    'preload'  => Optional[Array]
  }] $modules_config                             = $asterisk::params::modules_config,
  Struct[{
    'general' => Hash[String, NotUndef],
  }] $manager_config                             = $asterisk::params::manager_config,
  Hash[String, Struct[{
    'driver'    => String,
    'database'  => String,
    'table'     => String
  }]] $realtime_options                          = $asterisk::params::realtime_options,
  Struct[{
    'general'   => Hash[String, NotUndef],
    'logfiles'  => Hash[String, NotUndef]
  }] $logger_options                             = $asterisk::params::logger_options,
  Struct[{
    'general'                => Optional[Hash[String, NotUndef]],
    'backends'               => Optional[Hash[String, NotUndef]],
    'mappings'               => Optional[Hash[String, Array[String]]],
    'manager'                => Optional[Struct[{
      'general'   => Hash[String, NotUndef],
      'mappings'  => Hash[String, String],
    }]
    ],
    'backend_special_config' => Optional[Hash[String, Struct[{
      'enable' => Boolean,
      'config' => Hash[String, NotUndef],
    }]
    ]],
  }] $cdr_config                                = $asterisk::params::cdr_config,
  Struct[{
    'enable'      => Boolean,
    'connections' => Hash[String, NotUndef]
  }] $res_config_mysql_config                   = $asterisk::params::res_config_mysql_config,
  Struct[{
    'general' => Hash[String, NotUndef]
  }] $meetme_config                             = $asterisk::params::meetme_config,
  Struct[{
    'enabled' => Boolean,
    'groups'  => Hash[Integer, Hash[String, NotUndef]],
    'global'  => Optional[Hash[String, NotUndef]],
  }] $chan_dahdi_config                         = $asterisk::params::chan_dahdi_config,
  Struct[{
    'enabled' => Boolean,
    'config'  => Optional[Struct[{'general' => Hash[String, NotUndef]}]]
  }] $stun_config                               = $asterisk::params::stun_config,
  Struct[{
    'general'             => Hash[String, NotUndef],
    'ice_host_candidates' => Optional[Hash[String, NotUndef]],
    'udptl'               => Optional[Hash[String, NotUndef]],
  }] $rtp_config                                = $asterisk::params::rtp_config,
  Struct[{
    'general'             => Hash[String, NotUndef],
  }] $http_config                                = $asterisk::params::http_config,
  Struct[{
    'general'             => Hash[String, NotUndef],
  }] $festival_config                                = $asterisk::params::festival_config,
  Struct[{
    'general'             => Hash[String, NotUndef],
  }] $app_mysql_config                                = $asterisk::params::app_mysql_config,
  Struct[{
    'general'             => Optional[Hash[String, NotUndef]],
  }] $amd_config                                = $asterisk::params::amd_config,
  Struct[{
    'general'             => Optional[Hash[String, NotUndef]],
    'default'             => Optional[Hash[String, NotUndef]],
  }] $moh_config                                = $asterisk::params::moh_config,
  Struct[{
    'general'             => Optional[Hash[String, NotUndef]],
  }] $privacy_config                                = $asterisk::params::privacy_config,
  Struct[{
    'ENV'                 => Hash[String, NotUndef],
    'asterisk'            => Hash[String, NotUndef],
  }] $res_odbc_config                           = $asterisk::params::res_odbc_config,
  Struct[{
    'speex'             => Optional[Hash[String, NotUndef]],
    'plc'               => Optional[Hash[String, NotUndef]],
    'silk8'             => Optional[Hash[String, NotUndef]],
    'silk12'            => Optional[Hash[String, NotUndef]],
    'silk16'            => Optional[Hash[String, NotUndef]],
    'silk24'            => Optional[Hash[String, NotUndef]],
  }] $codecs_config                                = $asterisk::params::codecs_config,
  Struct[{
    'test_sorcery_section'              => Optional[Hash[String, NotUndef]],
    'test_sorcery_cache'                => Optional[Hash[String, NotUndef]],
    'res_mwi_external'                  => Optional[Hash[String, NotUndef]],
    'res_pjsip'                         => Optional[Hash[String, NotUndef]],
    'res_pjsip_endpoint_identifier_ip'  => Optional[Hash[String, NotUndef]],
    'res_pjsip_outbound_publish'        => Optional[Hash[String, NotUndef]],
    'res_pjsip_pubsub'                  => Optional[Hash[String, NotUndef]],
    'res_pjsip_publish_asterisk'        => Optional[Hash[String, NotUndef]],
  }] $sorcery_config                                = $asterisk::params::sorcery_config,
  Struct[{
    'general'           => Optional[Hash[String, NotUndef]],
    'system'            => Optional[Hash[String, NotUndef]],
    'global'            => Optional[Hash[String, NotUndef]],
    'transport-tcp'     => Optional[Hash[String, NotUndef]],
    'transport-udp'     => Optional[Hash[String, NotUndef]],
    'transport-tls'     => Optional[Hash[String, NotUndef]],
  }] $pjsip_config                                = $asterisk::params::pjsip_config,
  Struct[{
    'clear-mwi'             => Optional[Hash[String, NotUndef]],
    'aastra-check-cfg'      => Optional[Hash[String, NotUndef]],
    'aastra-xml'            => Optional[Hash[String, NotUndef]],
    'digium-check-cfg'      => Optional[Hash[String, NotUndef]],
    'linksys-cold-restart'  => Optional[Hash[String, NotUndef]],
    'linksys-warm-restart'  => Optional[Hash[String, NotUndef]],
    'polycom-check-cfg'     => Optional[Hash[String, NotUndef]],
    'sipura-check-cfg'      => Optional[Hash[String, NotUndef]],
    'sipura-get-report'     => Optional[Hash[String, NotUndef]],
    'snom-check-cfg'        => Optional[Hash[String, NotUndef]],
    'snom-reboot'           => Optional[Hash[String, NotUndef]],
    'cisco-check-cfg'       => Optional[Hash[String, NotUndef]],
  }] $pjsip_notify_config                                = $asterisk::params::pjsip_notify_config,
) inherits asterisk::params {

  $real_manage_service = deep_merge_extended(
    $asterisk::params::manage_service,
    $manage_service
  )

  $real_manage_package = deep_merge_extended(
    $asterisk::params::manage_package,
    $manage_package
  )

  $real_res_config_mysql_config = deep_merge_extended(
    $asterisk::params::res_config_mysql_config,
    $res_config_mysql_config
  )

  $real_asterisk_options = deep_merge_extended(
    $asterisk::params::asterisk_options,
    $asterisk_options
  )

  $real_iax_options = deep_merge_extended (
    $asterisk::params::iax_options,
    $iax_options
  )

  $real_sip_options = deep_merge_extended (
    $asterisk::params::sip_options,
    $sip_options
  )

  $real_voicemail_options = deep_merge_extended(
    $asterisk::params::voicemail_options, $voicemail_options
  )

  $real_extensions_options = deep_merge_extended(
    $asterisk::params::extensions_options,
    $extensions_options
  )

  $real_features_options = deep_merge_extended(
    $asterisk::params::features_config,
    $features_config,
  )
  $real_parking_options = deep_merge_extended(
    $asterisk::params::parking_config,
    $parking_config,
  )
  $real_queues_options = deep_merge_extended(
    $asterisk::params::queues_options,
    $queues_options
  )

  $real_realtime_options = deep_merge_extended(
    $asterisk::params::realtime_options,
    $realtime_options
  )

  $real_logger_options = deep_merge_extended(
    $asterisk::params::logger_options,
    $logger_options
  )

  $real_manager_options = deep_merge_extended(
    $asterisk::params::manager_config,
    $manager_config
  )


  # doing this one slightly different to ensure that modules specified for loading aren't
  # duplicated with an internal noload tht would block a configuration file

  $real_modules_config = deep_merge_extended(
    $asterisk::params::modules_config,
    $modules_config
  )

  $real_meetme_config = deep_merge_extended(
    $asterisk::params::meetme_config,
    $meetme_config
  )

  $real_sip_notifies = deep_merge_extended(
    $asterisk::params::sip_notifies,
    $sip_notifies
  )

  $real_cdr_config = deep_merge_extended(
    $asterisk::params::cdr_config,
    $cdr_config
  )

  $real_chan_dahdi_config = deep_merge_extended(
    $asterisk::params::chan_dahdi_config,
    $chan_dahdi_config
  )

  $real_stun_config = deep_merge_extended(
    $asterisk::params::stun_config,
    $stun_config
  )

  $real_rtp_config = deep_merge_extended (
    $asterisk::params::rtp_config,
    $rtp_config
  )

  $real_http_config = deep_merge_extended(
    $asterisk::params::http_config,
    $http_config
  )

  $real_festival_config = deep_merge_extended(
    $asterisk::params::festival_config,
    $festival_config
  )

  $real_amd_config = deep_merge_extended(
    $asterisk::params::amd_config,
    $amd_config
  )

  $real_moh_config = deep_merge_extended(
    $asterisk::params::moh_config,
    $moh_config
  )
  $real_privacy_config = deep_merge_extended(
    $asterisk::params::privacy_config,
    $privacy_config
  )
  $real_sorcery_config = deep_merge_extended(
    $asterisk::params::sorcery_config,
    $sorcery_config
  )
  $real_res_odbc_config = deep_merge_extended(
    $asterisk::params::res_odbc_config,
    $res_odbc_config
  )

  $real_app_mysql_config = deep_merge_extended(
    $asterisk::params::app_mysql_config,
    $app_mysql_config
  )

  $real_codecs_config = deep_merge_extended(
    $asterisk::params::codecs_config,
    $codecs_config
  )

  $real_pjsip_config = deep_merge_extended(
    $asterisk::params::pjsip_config,
    $pjsip_config
  )
  $real_pjsip_notify_config = deep_merge_extended(
    $asterisk::params::pjsip_notify_config,
    $pjsip_notify_config
  )

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up. You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'asterisk::begin': }
  ->
  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
        # rhel-based
        class { '::asterisk::repos::rhel': }
    }
    'Debian', 'Ubuntu': {
        class { '::asterisk::repos::debian': }
    }
    default: {
      fail("\"${module_name}\" provides no packages for \"${::operatingsystem}\"")
    }
  }
  -> class { '::asterisk::install': }
  -> class { '::asterisk::config': }
  ~> class { '::asterisk::service': }
  -> anchor { 'asterisk::end': }

}
