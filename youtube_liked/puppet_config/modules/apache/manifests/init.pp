class apache (
    $apachename = $::apache::params::apachename,
) inherits apache::params {

    notify {"in apache. $apachename":}
    package { 'httpd':
        name => $apachename,
        ensure => 'installed',
    }
    service {'httpd':
        ensure => 'running',
        require => Package['httpd']
    }

}
