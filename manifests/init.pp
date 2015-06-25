class ntp (
  $driftfile       = $ntp::params::driftfile,
  $package_ensure  = $ntp::params::package_ensure,
  $package_name    = $ntp::params::package_name,
  $config_template = $ntp::params::config_template,
  $servers         = $ntp::params::servers,
  $service_enable  = $ntp::params::service_enable,
  $service_ensure  = $ntp::params::service_ensure,
  $service_manage  = $ntp::params::service_manage,
  $service_name    = $ntp::params::service_name,
  $logfile         = $ntp::params::logfile) inherits ntp::params {
  validate_absolute_path($driftfile)
  validate_string($package_ensure)
  validate_array($package_name)
  validate_array($servers)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_string($service_name)
  validate_absolute_path($logfile)

  #motd::register { "Ntp": }
  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'ntp::begin': } ->
  class { '::ntp::install': } ->
  class { '::ntp::config': } ~>
  class { '::ntp::service': } ->
  anchor { 'ntp::end': }

}
