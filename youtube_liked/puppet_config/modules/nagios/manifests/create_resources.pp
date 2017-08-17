class nagios::create_resources inherits nagios {

  include $nagios::params

  ## Notify for debugging
  notify{ "Importing nagios host configs for $environment.":}


# import nagios host configs (includes templates)
#  Nagios_host <<| tag == ${environment} |>> {
  Nagios_host <<||>> {
  }

  Nagios_hostgroup <<||>> {
  }

  Nagios_servicegroup <<||>> {
  }

  Nagios_contact <<||>> {
  }

  Nagios_contactgroup <<||>> {
  }

  Nagios_command <<||>> {
  }

  Nagios_service <<||>> {
  }
}
