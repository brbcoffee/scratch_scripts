class nagios::add_object inherits nagios {
    create_resources( nagios::add_nagios_service, $machine_health_snmp_monitors) 
    create_resources( nagios::add_nagios_snmp_command, $machine_health_snmp_monitors)
    create_resources( nagios::add_nagios_servicetemplate, $nagios_servicetemplates)
    create_resources( nagios::add_nagios_contactgroup, $nagios_contactgroups)
    create_resources( nagios::add_nagios_hostgroup, $nagios_hostgroups_servicegroups_hosttemplates)
    create_resources( nagios::add_nagios_servicegroup, $nagios_hostgroups_servicegroups_hosttemplates )
    create_resources( nagios::add_nagios_hosttemplate_from_role, $nagios_hostgroups_servicegroups_hosttemplates )

  define nagios::add_nagios_service ( 
    $object               = "${name}",
    $myPath               = $::nagios::params::nagiosPuppetizedPath, 
    $servicegroups        = $servicegroups,  
    $service_description  = $service_description, 
    $command_line         = $command_line, 
    $contact_groups       = $contact_groups,
    $check_command,
    $use, 
    $hostgroup_name 
  ) {
    notify{ "in add service $myPath $object":}
    # Define defaults, can be overridden
    Nagios_service {
      ensure              => present,
      mode                => "0444",
      target              => "${myPath}/services/${object}.cfg",
      service_description => "${service_description}",
      check_command       => "${check_command}",
      contact_groups      => "${contact_groups}",
      hostgroup_name      => "${hostgroup_name}",
      servicegroups       => "${servicegroups}",
      use                 => "${use}",
      name                => "$object"
    }
    nagios_service { $object: }
  }

  define nagios::add_nagios_snmp_command ( 
    $object           = "${name}",
    $myPath           = $::nagios::params::nagiosPuppetizedPath,
    $nagios_env_var   = $::nagios::params::nagios_env_var,
    $instances        = $instances,
    $use, 
    $hostgroup_name, 
    $check_command    = $check_command,
    $service_description, 
    $command_line     = $command_line,
    $community_string = $::nagios::params::community_string,
    $servicegroups, 
    $contact_groups   = $contact_groups
  ) {
    # Define defaults, can be overridden
    # notify {"creating: $object in ${myPath}":}
    Nagios_command {
        ensure       => present,
        mode         => "0444",
        target       => "${myPath}/commands/${object}.cfg",
        command_name => "${object}",
        command_line => "${command_line} ${community_string}"
    }
    nagios_command { $object: }
  }

  define nagios::add_nagios_servicetemplate( 
    $object                = $name,
    $myPath                = $::nagios::params::nagiosPuppetizedPath,
    $normal_check_interval, 
    $check_command         = $check_command,
    $retry_check_interval, 
    $active_checks_enabled = $active_checks_enabled
  ) {
    # Define defaults, can be overridden
    Nagios_service {
      ensure                       => present,
      mode                         => "0444",
      target                       => "${myPath}/service-templates/${object}.cfg",
      service_description          => "$object",
      name                         => "$object",
      active_checks_enabled        => "${active_checks_enabled}",
      passive_checks_enabled       => "1",
      parallelize_check            => "1",
      obsess_over_service          => "0",
      check_freshness              => "0",
      notifications_enabled        => "1",
      event_handler_enabled        => "0",
      flap_detection_enabled       => "0",
      process_perf_data            => "0",
      retain_status_information    => "1",
      retain_nonstatus_information => "1",
      is_volatile                  => "0",
      check_period                 => "24x7",
      notification_period          => "24x7",
      max_check_attempts           => "4",
      normal_check_interval        => "${normal_check_interval}",
      notification_interval        => "0",
      notification_options         => "n",
      retry_check_interval         => "15",
      register                     => "0",
    }
    nagios_service { $object: }
  }    

  define nagios::add_nagios_contactgroup ( 
    $object         = "${name}_contactgroup",
    $members        = "${name}_contact",
    $crit           = $::nagios::params::host_criticality,
    $myPath         = $::nagios::params::nagiosPuppetizedPath,
    $nagios_env_var = $::nagios::params::nagios_env_var
  ) {
    # Define defaults, can be overridden
    # notify {"creating: $object in ${myPath}":}
    Nagios_contactgroup {
      ensure  => present,
      mode    => "0444",
      target  => "${myPath}/contactgroups/${object}.cfg",
      members => "${members}",
    }
    nagios_contactgroup { $object: }
  }

  define nagios::add_nagios_hostgroup ( 
    $object = $name,
    $myPath = $::nagios::params::nagiosPuppetizedPath 
  ) {
    # Define defaults, can be overridden
    Nagios_hostgroup {
      ensure => present,
      mode   => "0444",
      target => "${myPath}/hostgroups/${object}.cfg",
    }

    nagios_hostgroup { $object: }
  }

  define nagios::add_nagios_servicegroup ( 
    $object = $name,
    $myPath = $::nagios::params::nagiosPuppetizedPath 
  ) {
    # Define defaults, can be overridden
    Nagios_servicegroup {
      ensure => present,
      mode   => "0444",
      target => "${myPath}/servicegroups/${object}.cfg",
    }
    nagios_servicegroup { $object: }
  } 

  define nagios::add_nagios_hosttemplate_from_role ( 
    $object = $name,
    $myPath = $::nagios::params::nagiosPuppetizedPath 
  ) {
    Nagios_host {
      ensure     => present,
      mode       => "0444",
      target     => "${myPath}/host-templates/${object}.cfg",
      register   => 0,
      hostgroups => "+${object}"
    }
    nagios_host { $object: }
  }

}
