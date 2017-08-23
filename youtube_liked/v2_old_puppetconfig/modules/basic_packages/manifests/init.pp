class basic_packages {
    package { 'screen':
        ensure => 'installed',
    }
    package { 'mlocate':
        ensure => 'installed',
    }
    package { 'tree':
        ensure => 'installed',
    }
    package { 'net-tools.x86_64':
        ensure => 'installed',
    }
    package { 'telnet.x86_64':
        ensure => 'installed',
    }
#    package { 'epel-release':
#        ensure => 'installed',
#    }
}
