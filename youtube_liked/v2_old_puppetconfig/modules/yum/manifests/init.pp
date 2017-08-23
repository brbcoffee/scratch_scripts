class yum {
    $packages_to_install = hiera_array("packages_to_install")

    exec { 'clean yum cache':
        command => '/usr/bin/yum clean all',
    }
    require yum::repos    
    #notify {"in yum class. OS == $::operatingsystem":}
    yum::install { $packages_to_install: }
    

}
