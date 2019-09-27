class io_weblogic (
  $ensure                    = $::io_weblogic::params::ensure,
  $java_home                 = $::io_weblogic::params::java_home,
  $tools_version             = $::io_weblogic::params::tools_version,
  $psft_install_user_name    = $::io_weblogic::params::psft_install_user_name,
  $oracle_install_group_name = $::io_weblogic::params::oracle_install_group_name,
  $domain_user               = $::io_weblogic::params::domain_user,
  $pia_domain_list           = $::io_weblogic::params::pia_domain_list,
  $install_jce               = $::io_weblogic::params::install_jce,
  $trustcacerts              = $::io_weblogic::params::trustcacerts,
  $standard_java_trust       = $::io_weblogic::params::standard_java_trust,
  $pskey_passwd              = $::io_weblogic::params::pskey_passwd,
  $cacert_passwd             = $::io_weblogic::params::cacert_passwd,
  # $java_options              = $::io_weblogic::params::java_options,
  $certificates              = $::io_weblogic::params::certificates,
  $jce_path                  = $::io_weblogic::params::jce_path,
  $prebuilt_pskey            = $::io_weblogic::params::prebuilt_pskey,
  $psft_runtime_user_name    = $::io_weblogic::params::psft_runtime_user_name,
  $psft_install_user_name    = $::io_weblogic::params::psft_install_user_name,
  $oracle_install_group_name = $::io_weblogic::params::oracle_install_group_name,
  $omc_apm_agent             = $::io_weblogic::params::omc_apm_agent,
  $apm_install_dir           = $::io_weblogic::params::apm_install_dir,
  $apm_reg_key               = $::io_weblogic::params::apm_reg_key,
) inherits ::io_weblogic::params {

  #if ($java_options != undef) {
    contain ::io_weblogic::java_options
  #}

  if ($certificates != undef) or ($pskey_passwd != 'password'){
    contain ::io_weblogic::pskey
  }

  if ($standard_java_trust) or ($cacert_passwd != 'changeit'){
    contain ::io_weblogic::cacert
  }

  if ($install_jce){
    contain ::io_weblogic::jce
  }

  if ($prebuilt_pskey){
    contain ::io_weblogic::prebuilt_pskey
  }

  if ($omc_apm_agent){
    contain ::io_weblogic::omc_apm_agent
  }
}
