class io_weblogic::jce (
  $ensure                   = io_weblogic::params::ensure,
  $jce_path                 = io_weblogic::params::jce_path,
  $java_home                = io_weblogic::params::java_home,
  $extract_command          = io_weblogic::params::extract_command,
  $psft_install_user_name   = io_weblogic::params::psft_install_user_name,
  $oracle_install_user_name = io_weblogic::params::oracle_install_user_name,
) inherits io_weblogic::params {

  $security_dir = "${java_home}/jre/lib/security"

  archive "Oracle JCE from ${jce_path}" :{
    ensure          => $ensure,
    user            => $psft_install_user_name,
    group           => $oracle_install_user_name,
    extract         => true,
    source          => $jce_path,
    cookie          => 'oraclelicense=accept-securebackup-cookie',
    extract_path    => "${security_dir}/jre/lib/security",
    extract_command => "${extract_command}${security_dir}",
    creates         => "${security_dir}/README.txt",
    cleanup         => true,
  }
}
