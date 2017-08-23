class apache::params {
        
  if $::osfamily == 'RedHat' {
    $apachename     = 'httpd'        
  } elsif $::osfamily == 'Debian' {
    $apachename     = 'apache2'
  } else {
    print "This is not a supported distro."
  }
        
}
