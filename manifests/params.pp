class io_weblogic::params {
  $ensure                    = 'present'
  $domain_user               = 'psadm2'
  $pskey_passwd              = 'password'
  $cacert_passwd             = 'changeit'
  $java_home                 = undef
  $tools_version             = undef
  $pia_domain_list           = hiera('pia_domain_list')
  $install_jce               = false
  $trustcacerts              = false
  $standard_java_trust       = false
  # $java_options              = undef
  $certificates              = undef
  $jce_path                  = undef
  $prebuilt_pskey            = undef
  $psft_runtime_user_name    = hiera('psft_runtime_user_name', 'psadm2')
  $psft_install_user_name    = hiera('psft_install_user_name', 'psadm1')
  $oracle_install_group_name = hiera('oracle_install_group_name', 'oinstall')
  $omc_apm_agent             = undef
  $apm_install_dir           = undef
  $apm_reg_key               = undef

  if $java_options    { validate_hash($java_options)    }
  if $certificates    { validate_hash($certificates)    }
  if $pia_domain_list { validate_hash($pia_domain_list) }

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
