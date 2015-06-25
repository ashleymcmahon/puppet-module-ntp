class ntp::params {

  $package_ensure    = 'present'
  $preferred_servers = ['obdmgt00','obdmgt01']
  $service_enable    = true
  $service_ensure    = 'running'
  $service_manage    = true
  $config_template   = 'ntp/ntp.conf.erb'
  

  # On virtual machines allow large clock skews.
  $panic = str2bool($::is_virtual) ? {
    true    => false,
    default => true,
  }

  case $::osfamily {
    'RedHat': {
      $config          = '/etc/ntp.conf'
      $driftfile       = '/var/lib/ntp/ntp.drift'
      $package_name    = [ 'ntp' ]
      $service_name    = 'ntpd'
      $logfile         = '/var/log/ntp'
      $servers         = ['obdmgt00','obdmgt01']
    }
    'SuSE': {
      $config          = '/etc/ntp.conf'
      $driftfile       = '/var/lib/ntp/drift/ntp.drift'
      $package_name    = [ 'ntp' ]
      $logfile           = '/var/log/ntp'
      $service_name    = 'ntp'
      $servers         = ['obdmgt00','obdmgt01']
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
