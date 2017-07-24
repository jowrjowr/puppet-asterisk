# Install packages that are necessary for an asterisk server.
class asterisk::install {

  # TODO: make packages dependend on loaded modules
  if $asterisk::real_manage_package['manage_package'] {
    ensure_packages([
      $asterisk::real_manage_package['package_name'],
      "${asterisk::real_manage_package['package_name']}-dahdi",
      "${asterisk::real_manage_package['package_name']}-devel",
      "${asterisk::real_manage_package['package_name']}-sounds-core-en-alaw.noarch",
      "${asterisk::real_manage_package['package_name']}-mysql",
      "${asterisk::real_manage_package['package_name']}-iax2",
      "${asterisk::real_manage_package['package_name']}-sip",
      "${asterisk::real_manage_package['package_name']}-snmp"],
      { 'provider' => 'yum',
        'ensure'   => 'present',
        'require'  => [
          Yumrepo['asterisk-common'],
          Yumrepo['asterisk-13']
        ]
      }
    )

    ensure_packages([
      $asterisk::real_manage_package['package_name'],
      'asterisk-sounds-core-en',
      'asterisk-sounds-core-en-gsm',
    ],
    {
      ensure => installed
    }
    )
  }

  if $asterisk::real_manage_package['manage_directories'] {
    if has_key($asterisk::real_asterisk_options['directories'], 'astetcdir') and $asterisk::real_asterisk_options['directories']['astetcdir'] != $asterisk::confdir {
      notify { "The defined 'astetcdir' is different from where this module will generate the configruation in. Please adjust.":
          loglevel => 'error',
      }
    }

    unique(values($asterisk::real_asterisk_options['directories'])).each |String $dir| {
      exec { "${dir}_mkdir":
        command => "mkdir -p ${dir}",
        unless  => "test -d ${dir}",
        path    => ['/bin', '/usr/bin'],
      }
      -> file { $dir:
        ensure => 'directory',
        mode   => $asterisk::params::default_directory_perm,
        owner  => $asterisk::params::asterisk_runuser_grp,
        group  => $asterisk::params::asterisk_runuser_grp,
      }
    }
  }

}
