class io_weblogic::params (
  $ensure               = hiera('ensure', 'present'),
  $java_home            = hiera('jdk_location'),
  $pia_domain_list      = hiera_hash('pia_domain_list'),
  $pskey_passwd         = 'password',
  $cacert_passwd        = 'changeit',
  $trustcacerts         = true,
  $standard_java_trust  = true,
  $rename_pia_cookie    = false,
  $java_options         = undef,
  $certificates         = undef,
  $pia_cookie_name      = undef,
){

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
    }
    default:   {
      $platform = 'LINUX'
      $setenv   = 'setEnv.sh'
    }
  }

  validate_hash($java_options)
  validate_hash($certificates)
  validate_hash($pia_domain_list)
}
