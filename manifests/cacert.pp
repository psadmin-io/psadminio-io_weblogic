class io_weblogic::cacert (
  $pia_domain_list     = $io_weblogic::params::pia_domain_list,
  $java_home           = $io_weblogic::params::java_home,
  $password            = $io_weblogic::params::cacert_passwd,
  $standard_java_trust = $io_weblogic::params::standard_java_trust,
  $setenv              = $io_weblogic::params::setenv,
) inherits io_weblogic::params {

  $cacert_location    = "${java_home}/jre/lib/security/cacerts"

  exec { "Set the cacert password for ${cacert_location}":
    command => "keytool -keystore ${cacert_location} -storepass changeit -storepasswd -new ${password}",
    onlyif  => "keytool -list -keystore ${cacert_location} -storepass ${password} |/bin/grep \"password was incorrect\"",
    path    => "${java_home}/jre/bin/",
    #require => Pt_webserver_domain[$pia_domain_name],
  }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    if $standard_java_trust {
      file_line { 'Set javax.net.ssl.trustStore from delivered to cacerts':
        ensure => present,
        path   => "${ps_cfg_home_dir}/webserv/${domain_name}/bin/${setenv}",
        line   => "SSL_KEY_STORE_PATH=${cacert_location}",
        match  => '^SSL_KEY_STORE_PATH=.*'
      }
    }
  }
}
