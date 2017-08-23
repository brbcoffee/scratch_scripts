define nagios::setupNagiosPaths($ensure=directory) {

  file {
      "$name":
        path    => $name,
        ensure  => $ensure,
        purge   => true,
        force   => true,
        recurse => false,
        mode    => "0775"
    }
}
