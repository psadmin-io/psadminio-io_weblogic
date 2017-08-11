class io_weblogic::pskey (
  $ps_config_home  = hiera('ps_config_home'),
  $pia_domain_name = hiera('pia_domain_name'),
  $password        = 'password', # This is the default as delivered, if you add a private cert change it.
  $keys            = undef,
  $java_home       = hiera('jdk_location'),
  $trustcacerts    = true,
){

  $pskey_location = "${ps_config_home}/webserv/${pia_domain_name}/piaconfig/keystore/pskey"

  exec { "Set the pskey password for ${ps_config_home}/webserv/${pia_domain_name}/piaconfig/keystore/pskey" :
    command => "keytool -keystore ${pskey_location} -storepass password -storepasswd -new ${password}",
    onlyif  => "keytool -list -keystore ${pskey_location} -storepass ${password} |grep \"password was incorrect\"",
    path    => "${java_home}/jre/bin/",
    require => Pt_webserver_domain[$pia_domain_name],
  }

  Java_ks {
    ensure       => latest,
    target       => $pskey_location,
    password     => $password,
    trustcacerts => $trustcacerts,
    require  => [Pt_webserver_domain[$pia_domain_name], Exec['keystore_password_pskey']],
  }

  $keys.each | $name, $value | {
    java_ks { "Adding ${name} to the pskey keystore for ${pia_domain_name}" :
      name        => $name,
      certificate => $value['certificate'],
      private_key => $value['private_key'],
      path        => "${java_home}/jre/bin/",
    }
  }
}
