class io_weblogic::cookie_name (
  $pia_domain_list = $io_weblogic::params::pia_domain_list,
  $pia_cookie_name = $io_weblogic::params::pia_cookie_name,
) inherits io_weblogic::params {

  $pia_domain_list.each |$domain_name, $pia_domain_info| {

    $ps_cfg_home_dir = $pia_domain_info['ps_cfg_home_dir']

    if (!$pia_cookie_name) {
      $pia_cookie_name = "${domain_name}-PSJSESSIONID"
    }

    notify { "domain: ${domain_name}" :}

    augeas { "${domain_name} weblogic.xml cookie-name" :
      lens    => 'Xml.lns',
      incl    => "${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/weblogic.xml",
      context => "/files/${ps_cfg_home_dir}/webserv/${domain_name}/applications/peoplesoft/PORTAL.war/WEB-INF/weblogic.xml/weblogic-web-app/session-descriptor/cookie-name",
      changes => "set #text ${pia_cookie_name}",
    }
  }
}
