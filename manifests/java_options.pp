class io_weblogic::java_options (
  $ensure          = hiera('ensure', 'present'),
  $ps_config_home  = hiera('ps_config_home'),
  $pia_domain_name = hiera('pia_domain_name'),
  $settings        = undef,
){

  validate_hash($settings)

  case $::facts['os']['name'] {
    'AIX':     {
      $platform = 'AIX'
      $script   = 'setEnv.sh'
    }
    'Solaris': {
      $platform = 'SOLARIS'
      $script   = 'setEnv.sh'
    }
    'windows': {
      $platform = 'WIN'
      $script   = 'setEnv.cmd'
    }
    default:   {
      $platform = 'LINUX'
      $script   = 'setEnv.sh'
    }
  }

  Ini_Subsetting {
    ensure               => $ensure,
    path                 => "${ps_config_home}/webserv/${pia_domain_name}/bin/${script}",
    setting              => "JAVA_OPTIONS_${platform}",
    subsetting_separator => ' -',
    section              => '',
  }

  $settings.each | $subset, $val | {
    ini_subsetting { "${pia_domain_name} WLS JAVA_OPTIONS_${platform}, ${subset}, ${val}" :
      subsetting => $subset,
      value      => $val,
    }
  }
}
