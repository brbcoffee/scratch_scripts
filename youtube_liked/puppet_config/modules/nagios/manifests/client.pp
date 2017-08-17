class nagios::client inherits nagios {

    $nagios_client_info_string = hiera("nagios_client_info")
    #$nagios_client_info_list = hiera_array("nagios_client_info")
    #$nagios_client_info_string = join($nagios_client_info_list, ",") #this info will determine the clients hosttemplates

    Nagios_host {
        ensure         => present,
        mode           => "0444",
        target         => "${nagiosPuppetizedPath}/hosts/${hostname}.cfg",
        host_name      => $fqdn,
        alias          => $fqdn,
        address        => $ipaddress_eth0,
        tag            => $environment,
        contact_groups => "$contact_group_string",
        use            => "$nagios_client_info_string",
    } 

    @@nagios_host { $hostname:
    }




}
