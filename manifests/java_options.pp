class io_weblogic::java_options (
  $ensure          = hiera('ensure', 'present'),
  $pia_domain_list = hiera_hash('pia_domain_list'),
  $settings        = undef,
){

  validate_hash($settings)

  case $::facts['os']['name'] {
    'AIX':     {
      $platform = 'AIX'
    }
    'Solaris': {
      $platform = 'SOLARIS'
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

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    Ini_Subsetting {
      ensure               => $ensure,
      path                 => "${ps_cfg_home_dir}/webserv/${domain_name}/bin/${script}",
      setting              => "JAVA_OPTIONS_${platform}",
      subsetting_separator => ' -',
      section              => '',
    }

    $settings["${domain_name}"].each | $subset, $val | {
      ini_subsetting { "${domain_name} WLS JAVA_OPTIONS_${platform}, ${subset}, ${val}" :
        subsetting => $subset,
        value      => $val,
      }
    }
  }
}
