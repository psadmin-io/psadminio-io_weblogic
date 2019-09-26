class io_weblogic::omc_apm_agent (
  $ensure = $io_weblogic::ensure,
  $pia_domain_list = $io_weblogic::pia_domain_list,
  $omc_apm_agent  = $io_weblogic::omc_apm_agent,
  $psft_runtime_user_name = $io_weblogic::psft_runtime_user_name,
  $oracle_install_group_name = $io_weblogic::oracle_install_group_name,
  $apm_install_dir = $io_weblogic::apm_install_dir,
  $apm_reg_key = $io_weblogic::apm_reg_key,
) inherits io_weblogic {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $apm_agent_location  = "${ps_cfg_home_dir}/webserv/${domain_name}"

    exec { "${domain_name}-OMC-RegistrationKey":
      ensure  => $ensure,
      command => "echo ${apm_reg_key} > ${apm_install_dir}/reg.txt",
    }
    -> exec {"${domain_name}-OMC-APMAgent":
      ensure  => $ensure,
      command => "chmod +x ${apm_install_dir}/ProvisionApmJavaAsAgent.sh && ${apm_install_dir}/ProvisionApmJavaAsAgent.sh -d ${apm_agent_location} -no-prompt -regkey-file ${apm_install_dir}/reg.txt -no-wallet",
      creates => "${domain_home}/apmagent",
      user    => $psft_runtime_user_name,
    }
    
  }
}
