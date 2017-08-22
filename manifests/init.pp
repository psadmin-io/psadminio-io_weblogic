class io_weblogic (
) inherits io_weblogic::params {

  if ($io_weblogic::params::java_options != undef) {
    contain ::io_weblogic::java_options
  }

  if ($io_weblogic::params::certificates != undef) or ($io_weblogic::params::pskey_passwd != 'password'){
    contain ::io_weblogic::pskey
  }

  if ($io_weblogic::params::standard_java_trust) or ($io_weblogic::params::cacert_passwd != 'password'){
    contain ::io_weblogic::cacert
  }
}
