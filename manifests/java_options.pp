class io_weblogic::java_options (
  $ensure          = $io_weblogic::params::ensure,
  $pia_domain_list = $io_weblogic::params::pia_domain_list,
  $settings        = $io_weblogic::params::java_options,
  $platform        = $io_weblogic::params::platform,
  $setEnv          = $io_weblogic::params::setEnv,
) inherits io_weblogic::params {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    Ini_Subsetting {
      ensure               => $ensure,
      path                 => "${ps_cfg_home_dir}/webserv/${domain_name}/bin/${setEnv}",
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
