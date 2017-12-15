class io_weblogic::params {
  $ensure                    = hiera('ensure', 'present')
  $java_home                 = hiera('jdk_location')
  $tools_version             = hiera('tools_version')
  $psft_install_user_name    = hiera('psft_install_user_name', undef)
  $oracle_install_group_name = hiera('oracle_install_group_name', undef)
  $domain_user               = hiera('domain_user', undef)
  $pia_domain_list           = hiera_hash('pia_domain_list')
  $install_jce               = false
  $trustcacerts              = false
  $standard_java_trust       = false
  $pskey_passwd              = 'password'
  $cacert_passwd             = 'changeit'
  $java_options              = undef
  $certificates              = undef
  $jce_path                  = undef

  if $java_options    { validate_hash($java_options)    }
  if $certificates    { validate_hash($certificates)    }
  if $pia_domain_list { validate_hash($pia_domain_list) }

  if (!$jce_path) {
    case $tools_version {
      /8\.54\.*/: {
        $jce_archive_path = 'http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip'
      }
      /8\.55\.*/: {
        $jce_archive_path = 'http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip'
      }
      /8\.56\.*/: {
        $jce_archive_path = 'http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip'
      }
      default: {
        fail("Module ${module_name} requires that you have tools_version defined in your hiera to download JCE from Oracle")
      }
    }
  }
  else {
    $jce_archive_path = $jce_path
  }

  case $::osfamily {
    'windows': {
      $platform        = 'WIN'
      $setenv          = 'setEnv.cmd'
      $extract_command = '7z e -y -o'
      $fileowner       = $domain_user
      $keystr_set      = 'SET SSL_KEY_STORE_PATH'
      $javaopt_set     = 'SET JAVA_OPTIONS_'
    }
    'AIX': {
      $platform = 'AIX'
      $setenv          = 'setEnv.sh'
      $extract_command = 'unzip -o -j %s -d '
      $fileowner       = $psft_install_user_name
      $keystr_set      = 'SSL_KEY_STORE_PATH'
      $javaopt_set     = 'JAVA_OPTIONS_'
    }
    'Solaris': {
      $platform = 'SOLARIS'
      $setenv          = 'setEnv.sh'
      $extract_command = 'unzip -o -j %s -d '
      $fileowner       = $psft_install_user_name
      $keystr_set      = 'SSL_KEY_STORE_PATH'
      $javaopt_set     = 'JAVA_OPTIONS_'
    }
    default: {
      $platform = 'LINUX'
      $setenv          = 'setEnv.sh'
      $extract_command = 'unzip -o -j %s -d '
      $fileowner       = $psft_install_user_name
      $keystr_set      = 'SSL_KEY_STORE_PATH'
      $javaopt_set     = 'JAVA_OPTIONS_'
    }
  }
}
