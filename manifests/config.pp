# Manage all of asterisk's basic configuration files.
class asterisk::config {

  asterisk::util::settings_to_file { "${asterisk::confdir}/asterisk.conf":
    standardsettings => {
      'options' => $asterisk::real_asterisk_options['options'],
      'files'   => $asterisk::real_asterisk_options['files'],
    },
    specialsettings  => {
      'directories' => {
        'data'        => $asterisk::real_asterisk_options['directories'],
        'sep'         => '=>',
        'is_template' => true,
      },
    },
  }

  if $asterisk::real_res_config_mysql_config['enable'] {
    asterisk::util::settings_to_file { "${asterisk::confdir}/res_config_mysql.conf":
      standardsettings => $asterisk::real_res_config_mysql_config['connections'],
    }
  }
  else {
    file { "${asterisk::confdir}/res_config_mysql.conf":
      ensure => absent,
    }
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/logger.conf":
    standardsettings => $asterisk::real_logger_options,
  }

  # TODO: update registry/iax_registry.pp
  asterisk::util::settings_to_file { "${asterisk::confdir}/iax.conf":
    standardsettings => $asterisk::real_iax_options,
    includes         => [
      "${asterisk::confdir}/iax.registry.d",
      "${asterisk::confdir}/iax.clients.d",
      "${asterisk::confdir}/iax.d",
    ],
  }

  # TODO: update registry/sip_registry.pp
  asterisk::util::settings_to_file { "${asterisk::confdir}/sip.conf":
    standardsettings => $asterisk::real_sip_options,
    includes         => [
      "${asterisk::confdir}/sip.d",
      "${asterisk::confdir}/sip.registry.d",
    ],
  }

  # TODO: create a defined to create a voicemail via asterisk::cfg:: define
  asterisk::util::settings_to_file { "${asterisk::confdir}/voicemail.conf":
    standardsettings => $asterisk::real_voicemail_options,
    includes         => ["${asterisk::confdir}/voicemail.d"],
  }

  # TODO: create a defined to create an extension file via asterisk::cfg:: define
  asterisk::util::settings_to_file { "${asterisk::confdir}/extensions.conf":
    standardsettings => $asterisk::real_extensions_options,
    includes         => ["${asterisk::confdir}/extensions.d"],
  }

  # TODO: create a defined to create a feature via asterisk::cfg:: define
  asterisk::util::settings_to_file { "${asterisk::confdir}/features.conf":
    standardsettings => { 'general' => $asterisk::real_features_options['general'] },
    includes         => ["${asterisk::confdir}/features.d"],
  }

  # TODO: create a defined to create a parkinglot via asterisk::cfg:: define
  asterisk::util::settings_to_file { "${asterisk::confdir}/res_parking.conf":
    standardsettings => { 'general' => $asterisk::real_features_options['parking'] },
    includes         => ["${asterisk::confdir}/parkinglots.d"],
  }

  # TODO: create a defined to create a queue via asterisk::cfg:: define
  asterisk::util::settings_to_file { "${asterisk::confdir}/queues.conf":
    standardsettings => $asterisk::real_queues_options,
    includes         => ["${asterisk::confdir}/queues.d"],
  }

  # TODO: create a defined to create a queuerule via asterisk::cfg:: define
  asterisk::util::settings_to_file { "${asterisk::confdir}/queuerules.conf":
    standardsettings => { 'general' => {} },
    includes         => ["${asterisk::confdir}/queuerules.d"],
  }

  # TODO: create a defined to create a manager via asterisk::cfg:: define
  asterisk::util::settings_to_file { "${asterisk::confdir}/manager.conf":
    standardsettings => $asterisk::real_manager_options,
    includes         => ["${asterisk::confdir}/manager.d"],
  }

  # TODO: create a defined to add modules via asterisk::cfg:: define
  asterisk::util::settings_to_file { "${asterisk::confdir}/modules.conf":
    standardsettings => { 'modules' => { 'autoload' => $asterisk::real_modules_config['autoload'] } },
    specialsettings  => {
      'preload' => {
        'sep'  => '=>',
        'data' => $asterisk::real_modules_config['preload'],
      },
      'noload'  => {
        'sep'  => '=>',
        'data' => $asterisk::real_modules_config['noload'],
      },
      'load'    => {
        'sep'  => '=>',
        'data' => $asterisk::real_modules_config['load'],
      },
    },
    includes         => ["${asterisk::confdir}/modules.d"],
  }

  # TODO: create a defined to add meetme rooms as asterisk::cfg:: define
  asterisk::util::settings_to_file { "${asterisk::confdir}/meetme.conf":
    standardsettings => merge($asterisk::real_meetme_config,
      { 'rooms' => {} }),
    includes         => ["${asterisk::confdir}/meetme.d"],
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/ari.conf":
    standardsettings => $asterisk::params::ari_config,
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/sip_notify.conf":
    standardsettings => $asterisk::sip_notifies,
    seperator        => '=>',
  }

  #
  # CDR
  #
  asterisk::util::settings_to_file { "${asterisk::confdir}/cdr.conf":
    standardsettings  => { 'general' => $asterisk::real_cdr_config['general'] },
    standardsettings2 => $asterisk::real_cdr_config['backends'],
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/cdr_custom.conf":
    standardsettings => { 'mappings' => $asterisk::real_cdr_config['mappings'] },
    seperator        => '=>',
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/cdr_manager.conf":
    standardsettings => { 'general' => $asterisk::real_cdr_config['manager'] },
    specialsettings  => {
      'mappings' => {
        'sep'  => '=>',
        'data' => $asterisk::real_cdr_config['manager']['mappings'],
      },
    },
  }

  notice($asterisk::real_cdr_config['backend_special_config'])
  if has_key($asterisk::real_cdr_config['backend_special_config'], 'cdr_mysql') and $asterisk::real_cdr_config['backend_special_config']['cdr_mysql']['enable'] {
    asterisk::util::settings_to_file { "${asterisk::confdir}/cdr_mysql.conf":
      standardsettings => $asterisk::real_cdr_config['backend_special_config']['cdr_mysql']['config'],
    }
  }
  else {
    file { "${asterisk::confdir}/cdr_mysql.conf":
      ensure => absent,
    }
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/cel.conf":
    standardsettings => $asterisk::params::cel_config,
  }
  asterisk::util::settings_to_file { "${asterisk::confdir}/cel_custom.conf":
    specialsettings => {
      'mappings' => {
        'sep'  => '=>',
        'data' => $asterisk::params::cel_config_mappings,
      },
    },
  }

  if $asterisk::real_chan_dahdi_config['enabled'] {
    asterisk::util::settings_to_file { "${asterisk::confdir}/chan_dahdi.conf":
      standardsettings         => delete($asterisk::real_chan_dahdi_config, 'enabled'),
      template                 => 'asterisk/chan_dahdi.conf.epp',
      special_separator_fields => { 'trunkgroup' => '=>', 'spanmap' => '=>', 'channel' => '=>' },
    }
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/cli.conf":
    standardsettings => $asterisk::params::cli_config,
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/cli_permissions.conf":
    standardsettings => $asterisk::params::cli_config_permissions,
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/dnsmgr.conf":
    standardsettings => $asterisk::params::cli_config_permissions,
  }

  # TODO: create a defined to add moh asterisk::cfg:: define
  asterisk::util::settings_to_file { "${asterisk::confdir}/musiconhold.conf":
    standardsettings => $asterisk::params::moh_config,
    includes         => ["${asterisk::confdir}/musiconhold.d"],
  }

  if $asterisk::real_stun_config['enabled'] {
    asterisk::util::settings_to_file { "${asterisk::confdir}/res_stun_monitor.conf":
      standardsettings => $asterisk::real_stun_config['config'],
    }
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/enum.conf":
    standardsettings => { 'general' => {} },
    specialsettings  => {
      'search'     => {
        'sep'  => '=>',
        'data' => $asterisk::params::enum_config['search'],
      },
      'h323driver' => {
        'sep'  => '=>',
        'data' => $asterisk::params::enum_config['h323driver'],
      },
    },
  }

  # this builds {'sipusers' => [driver,database,table], 'sippeers' => [driver,database,table]}
  $extconfig = hash_extended($asterisk::real_realtime_options.map |$index, $value| { [
    $index, [
      $value['driver'],
      $value['database'],
      $value['table'],
    ],
  ]}, 1)
  asterisk::util::settings_to_file { "${asterisk::confdir}/extconfig.conf":
    standardsettings => { 'settings' => $extconfig },
    seperator        => '=>',
  }

  $asterisk::real_modules_config['noload'].each |String $modulename| {
    if (has_key($asterisk::params::absent_configs_on_noload_modules, $modulename)) {
      $asterisk::params::absent_configs_on_noload_modules[$modulename].each |String $config_file| {
        file { "${asterisk::confdir}/${config_file}":
          ensure => 'absent',
        }
      }
    }
  }

  $module_path = get_module_path($module_name)
  augeas { "${asterisk::confdir}/indications.conf":
    changes   => [
      "set /files${asterisk::confdir}/indications.conf/general/country de",
      "set /files${asterisk::confdir}
        /indications.conf/general/country/#comment 'country parameter is managed by puppet - manual changes are overwritten'",
    ],
    load_path => "${module_path}/lib/augeas/lenses/",
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/rtp.conf":
    standardsettings => { 'general' => $asterisk::real_rtp_config['general'] },
    specialsettings  => {
      'ice_host_candidates' => {
        'data' => $asterisk::real_rtp_config['ice_host_candidates'],
        'sep'  => '=>',
      },
    },
  }
  asterisk::util::settings_to_file { "${asterisk::confdir}/udptl.conf":
    standardsettings => { 'general' => $asterisk::real_rtp_config['udptl'] },
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/stasis.conf":
    standardsettings => $asterisk::params::stasis_config,
  }
  asterisk::util::settings_to_file { "${asterisk::confdir}/statsd.conf":
    standardsettings => $asterisk::params::statsd_config,
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/acl.conf":
    standardsettings => {},
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/http.conf":
    standardsettings => { 'general' => $asterisk::real_http_config['general'] },
  }

  asterisk::util::settings_to_file { "${asterisk::confdir}/festival.conf":
    standardsettings => { 'general' => $asterisk::real_festival_config['general'] },
  }
  asterisk::util::settings_to_file { "${asterisk::confdir}/app_mysql.conf":
    standardsettings => { 'general' => $asterisk::real_app_mysql_config['general'] },
  }
  asterisk::util::settings_to_file { "${asterisk::confdir}/amd.conf":
    standardsettings => { 'general' => $asterisk::real_amd_config['general'] },
  }
  asterisk::util::settings_to_file { "${asterisk::confdir}/codecs.conf":
    standardsettings => { 
        'speex'     => $asterisk::real_codecs_config['speex'],
        'plc'       => $asterisk::real_codecs_config['plc'],
        'silk8'     => $asterisk::real_codecs_config['silk8'],
        'silk12'    => $asterisk::real_codecs_config['silk12'],
        'silk16'    => $asterisk::real_codecs_config['silk16'],
        'silk24'    => $asterisk::real_codecs_config['silk24'],
    },
  }

  #
  # cleanup unused files
  #
  $asterisk::params::unused_files.each |String $file| {
    file { "${asterisk::confdir}/${file}":
      ensure => 'absent',
    }
  }
}
