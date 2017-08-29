class io_weblogic::pskey (
  $pia_domain_list = $io_weblogic::params::pia_domain_list,
  $java_home       = $io_weblogic::params::java_home,
  $password        = $io_weblogic::params::pskey_passwd,
  $certificates    = $io_weblogic::params::certificates,
  $trustcacerts    = $io_weblogic::params::trustcacerts,
) inherits io_weblogic {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $pskey_location  = "${ps_cfg_home_dir}/webserv/${domain_name}/piaconfig/keystore/pskey"

    exec { "Set the pskey password for ${ps_cfg_home_dir}/webserv/${domain_name}/piaconfig/keystore/pskey" :
      command => "keytool -keystore ${pskey_location} -storepass password -storepasswd -new ${password}",
      onlyif  => "keytool -list -keystore ${pskey_location} -storepass ${password} |/bin/grep \"password was incorrect\"",
      path    => "${java_home}/jre/bin/",
    }

    Java_ks {
      ensure       => latest,
      target       => $pskey_location,
      password     => $password,
      trustcacerts => $trustcacerts,
      require      => Exec["Set the pskey password for ${ps_cfg_home_dir}/webserv/${domain_name}/piaconfig/keystore/pskey"],
    }

    $certificates["${domain_name}"].each | $name, $value | {
      java_ks { "Adding ${name} to the pskey keystore for ${domain_name}" :
        name        => $name,
        certificate => $value['certificate'],
        private_key => $value['private_key'],
        path        => "${java_home}/jre/bin/",
      }
    }
  }
}
