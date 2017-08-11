class apache (
    $apachename = $::apache::params::apachename,
) inherits apache::params {

    notify {"in apache":}
    package { 'httpd':
        name => $apachename,
        ensure => 'running',
	}

}
