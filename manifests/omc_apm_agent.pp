class io_weblogic::omc_apm_agent (
  $ensure = $io_weblogic::ensure,
  $pia_domain_list = $io_weblogic::pia_domain_list,
  $omc_apm_agent  = $io_weblogic::omc_apm_agent,
  $psft_runtime_user_name = $io_weblogic::psft_runtime_user_name,
  $oracle_install_group_name = $io_weblogic::oracle_install_group_name,
  $apm_install_dir = $io_weblogic::apm_install_dir,
  $apm_reg_key = $io_weblogic::apm_reg_key,
  $jdk_locaion = $io_weblogic::jdk_locaion,
) inherits io_weblogic {

  file {"${domain_name}-OMC-RegKey":
    ensure  => $ensure,
    path    => "${apm_install_dir}/reg.txt",
    content => $apm_reg_key,
    owner   => $psft_runtime_user_name,
    group   => $oracle_install_group_name,
    mode    => '0644',
  }
  
  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $apm_agent_location  = "${ps_cfg_home_dir}/webserv/${domain_name}"
    
    exec {"${domain_name}-OMC-APMAgent":
      command => "su -c 'export JAVA_HOME=${jdk_locaion} && export PATH=\$PATH:\$JAVA_HOME/bin && cd ${apm_install_dir} && /bin/chmod +x ProvisionApmJavaAsAgent.sh && ./ProvisionApmJavaAsAgent.sh -d ${apm_agent_location} -no-prompt -regkey-file ${apm_install_dir}/reg.txt -no-wallet' ${psft_runtime_user_name}",
      creates => "${domain_home}/apmagent",
      path    => "/sbin/:/usr/local/bin/:/usr/bin/:/bin/:${jdk_locaion}/bin/",
      cwd     => $apm_install_dir,
      # environment => ["JAVA_HOME=${java_home}", "PATH=\$PATH:\$JAVA_HOME/bin/"],
    }
    
  }
}
