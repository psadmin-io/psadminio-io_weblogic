class io_weblogic::cacert (
  $pia_domain_list     = $io_weblogic::pia_domain_list,
  $java_home           = $io_weblogic::java_home,
  $password            = $io_weblogic::cacert_passwd,
  $standard_java_trust = $io_weblogic::standard_java_trust,
  $setenv              = $io_weblogic::setenv,
  $keystr_set          = $io_weblogic::keystr_set,
) inherits io_weblogic {

  $cacert_location    = "${java_home}/jre/lib/security/cacerts"

  exec { "Set the cacert password for ${cacert_location}":
    command => "keytool -keystore ${cacert_location} -storepass changeit -storepasswd -new ${password}",
    unless  => "keytool -list -keystore ${cacert_location} -storepass ${password}",
    path    => "${java_home}/jre/bin/",
    #require => Pt_webserver_domain[$pia_domain_name],
  }

  if ( $standard_java_trust ) {
    $pia_domain_list.each |$domain_name, $pia_domain_info| {

      $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

      file_line { 'Set javax.net.ssl.trustStore from delivered to cacerts':
        ensure => present,
        path   => "${ps_cfg_home_dir}/webserv/${domain_name}/bin/${setenv}",
        line   => "${keystr_set}=${cacert_location}",
        match  => "^${keystr_set}=.*"
      }
    }
  }
}
