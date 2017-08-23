class nagios::server() inherits nagios {

    Nagios::SetupNagiosPaths <| |>      
    $subdirs = [ 
         "$nagiosPuppetizedPath",
         "$nagiosPuppetizedPath/commands", 
         "$nagiosPuppetizedPath/contactgroups", 
         "$nagiosPuppetizedPath/contacts",
         "$nagiosPuppetizedPath/hostgroups",
         "$nagiosPuppetizedPath/hosts",
         "$nagiosPuppetizedPath/host-templates",
         "$nagiosPuppetizedPath/scripts",
         "$nagiosPuppetizedPath/servicegroups",
         "$nagiosPuppetizedPath/services",
         "$nagiosPuppetizedPath/service-templates",
   ]

    setupnagiospaths {
        $subdirs: ensure => directory;
    }

}
