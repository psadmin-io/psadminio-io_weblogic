class io_weblogic::prebuilt_pskey (
  $ensure = $io_weblogic::ensure,
  $pia_domain_list = $io_weblogic::pia_domain_list,
  $prebuilt_pskey  = $io_weblogic::prebuilt_pskey,
  $psft_runtime_user_name = $io_weblogic::psft_runtime_user_name,
  $oracle_install_group_name = $io_weblogic::oracle_install_group_name
) inherits io_weblogic {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $pskey_location  = "${ps_cfg_home_dir}/webserv/${domain_name}/piaconfig/keystore/pskey"

    file {"pskey-${$pskey_location}":
      ensure => $ensure,
      source => $prebuilt_pskey,
      path   => $pskey_location,
      owner  => $psft_runtime_user_name,
      group  => $oracle_install_group_name,
      mode   => '0644',
    }
  }
}
