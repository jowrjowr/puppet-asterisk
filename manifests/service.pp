# Ensure the Asterisk service is running.
#
class asterisk::service {
  if $asterisk::real_manage_service['manage_service'] {
    service { $asterisk::real_manage_service['service_name']:
      ensure     => running,
      hasrestart => true,
    }

    if has_key($asterisk::real_manage_service, 'service_restart_command') {
      Service[$asterisk::real_manage_service['service_name']] {
        restart => $asterisk::real_manage_service['service_restart_command']
      }
    }
  }
}