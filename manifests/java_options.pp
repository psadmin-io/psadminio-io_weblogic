class io_weblogic::java_options (
  $ensure          = $io_weblogic::ensure,
  $pia_domain_list = $io_weblogic::pia_domain_list,
  $settings        = $io_weblogic::java_options,
  $platform        = $io_weblogic::platform,
  $setenv          = $io_weblogic::setenv,
) inherits io_weblogic {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    Ini_Subsetting {
      ensure               => $ensure,
      path                 => "${ps_cfg_home_dir}/webserv/${domain_name}/bin/${setenv}",
      setting              => "${javaopt_set}${platform}",
      subsetting_separator => ' -',
      section              => '',
    }

    $settings["${domain_name}"].each | $subset, $val | {
      ini_subsetting { "${domain_name} WLS ${javaopt_set}${platform}, ${subset}, ${val}" :
        subsetting => $subset,
        value      => $val,
      }
    }
  }
}
