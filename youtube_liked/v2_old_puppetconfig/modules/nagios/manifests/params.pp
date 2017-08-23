class nagios::params () {
    
    $nagiosPuppetizedPath = hiera("nagiosPuppetizedPath")    
    $machine_health_snmp_monitors= hiera_hash("machine_health_snmp_monitors")
    $nagios_servicetemplates= hiera_hash("nagios_servicetemplates")
    $nagios_contactgroups= hiera_hash("nagios_contactgroups")
    $nagios_hostgroups_servicegroups_hosttemplates= hiera_hash("nagios_hostgroups_servicegroups_hosttemplates")

    $host_criticality = "normal"
    $myPath         = $::nagios::params::nagiosPuppetizedPath
    $nagios_env_var = "test"

}
