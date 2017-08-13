class io_weblogic::params (
  $ensure              = hiera('ensure', 'present'),
  $pia_domain_list     = hiera_hash('pia_domain_list'),
  $java_home           = hiera('jdk_location'),
  $pskey_passwd        = 'password',
  $cacert_passwd       = 'changeit',
  $trustcacerts        = true,
  $standard_java_trust = true,
  $java_options        = undef,
  $certificates        = undef,
){

  validate_hash($java_options)
  validate_hash($certificates)
  validate_hash($pia_domain_list)

  case $::facts['os']['name'] {
    'AIX':     {
      $platform = 'AIX'
    }
    'Solaris': {
      $platform = 'SOLARIS'
    }
    'windows': {
      $platform = 'WIN'
      $setEnv   = 'setEnv.cmd'
    }
    default:   {
      $platform = 'LINUX'
      $setEnv   = 'setEnv.sh'
    }
  }
}
