define yum::install (
    $packageToInstall = "${name}",
) {
    package { $packageToInstall:
      ensure	=> installed,
      require	=> Exec['clean yum cache']  
    }
}
