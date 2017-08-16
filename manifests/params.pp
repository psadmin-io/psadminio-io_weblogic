class io_weblogic::params (
  $ensure                    = hiera('ensure', 'present'),
  $java_home                 = hiera('jdk_location'),
  $pia_domain_list           = hiera_hash('pia_domain_list'),
  $tools_version             = hiera('tools_version'),
  $psft_install_user_name    = hiera('psft_install_user_name'),
  $oracle_install_group_name = hiera('oracle_install_group_name'),
  $pskey_passwd              = 'password',
  $cacert_passwd             = 'changeit',
  $install_jce               = true,
  $rename_pia_cookie         = false,
  $trustcacerts              = true,
  $standard_java_trust       = true,
  $java_options              = undef,
  $certificates              = undef,
  $jce_path                  = undef,
  $pia_cookie_name           = undef,
){

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

  case $::facts['os']['name'] {
    'AIX':     {
      $platform = 'AIX'
    }
    'Solaris': {
      $platform = 'SOLARIS'
    }
    'windows': {
      $platform = 'WIN'
      $setenv   = 'setEnv.cmd'
      $extract_command = '7z e -y -o'
    }
    default:   {
      $platform        = 'LINUX'
      $setenv          = 'setEnv.sh'
      $extract_command = 'unzip -o -j %s -d '
    }
  }

  validate_hash($java_options)
  validate_hash($certificates)
  validate_hash($pia_domain_list)
}
