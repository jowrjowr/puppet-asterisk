# Configure the contents of a file and create a corresponding .d configuration
# directory so that puppet can drop files for on-demand configuration snippets.
#
# $additional_paths lets one manage multiple .d directories while managing only
#   one configuration file. This trick is useful if some configuration snippets
#   need to be parsed before others (e.g. registries vs. contexts)
#
# $content is the configuration file contents
#
# $source is a puppet file source. If this is specified, $content will be
#   overridden. So one must not use both parameters at the same time.
#
# $manage_nullfile is a boolean value that decides if a null.conf file is
#   created in each .d directories. This file is necessary in empty .d dirs,
#   since asterisk will refuse to start if some included files do not exist.
#   Default is to create null.conf in all .d directories.
#
define asterisk::util::dotd (
  Array $additional_paths = [],
  Boolean $manage_nullfile  = true,
) {
  file { $additional_paths :
    ensure  => directory,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0750',
    purge   => true,
    recurse => true,
    require => Class['asterisk::install'],
  }

  if $manage_nullfile {
    # Avoid error messages
    # [Nov 19 16:09:48] ERROR[3364] config.c: *********************************************************
    # [Nov 19 16:09:48] ERROR[3364] config.c: *********** YOU SHOULD REALLY READ THIS ERROR ***********
    # [Nov 19 16:09:48] ERROR[3364] config.c: Future versions of Asterisk will treat a #include of a file that does not exist as an error, and will fail to load that configuration file.  Please ensure that the file '/etc/asterisk/iax.conf.d/*.conf' exists, even if it is empty.
    asterisk::util::dotdnullfile{ $additional_paths : }
  }
}
