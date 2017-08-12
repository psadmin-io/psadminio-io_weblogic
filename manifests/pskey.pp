class io_weblogic::pskey (
  $pia_domain_list = hiera('pia_domain_list'),
  $java_home       = hiera('jdk_location'),
  $password        = 'password', # This is the default as delivered, you should pass a new one from hiera
  $certificates    = undef,
  $trustcacerts    = false,
){

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']
    $pskey_location  = "${ps_cfg_home_dir}/webserv/${domain_name}/piaconfig/keystore/pskey"

    exec { "Set the pskey password for ${ps_cfg_home_dir}/webserv/${domain_name}/piaconfig/keystore/pskey" :
      command => "keytool -keystore ${pskey_location} -storepass password -storepasswd -new ${password}",
      onlyif  => "keytool -list -keystore ${pskey_location} -storepass ${password} |/bin/grep \"password was incorrect\"",
      path    => "${java_home}/jre/bin/",
      require => Pt_webserver_domain[$domain_name],
    }

    Java_ks {
      ensure       => latest,
      target       => $pskey_location,
      password     => $password,
      trustcacerts => $trustcacerts,
      require  => [Pt_webserver_domain[$domain_name], Exec["Set the pskey password for ${ps_cfg_home_dir}/webserv/${domain_name}/piaconfig/keystore/pskey"]],
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
