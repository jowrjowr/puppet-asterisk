# Create a file in .d directories to avoid service start issues (see cfg.pp)
define asterisk::util::dotdnullfile () {
  file {"${name}/null.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => Class['asterisk::install'],
    notify  => Class['asterisk::service'],
  }
}
