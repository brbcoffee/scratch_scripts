class yum::repos () {
    yumrepo { "epel-release":
      #baseurl => 'http://download.fedoraproject.org/pub/epel/6/$basearch',
      mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
      descr => "epel release repo",
      enabled => 1,
      gpgcheck => 0,
      priority => 10,

    }
 

}
