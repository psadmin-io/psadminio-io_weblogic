class io_weblogic::jce (
  $ensure                   = $io_weblogic::ensure,
  $jce_archive_path         = $io_weblogic::jce_archive_path,
  $java_home                = $io_weblogic::java_home,
  $extract_command          = $io_weblogic::extract_command,
  $fileowner                = $io_weblogic::fileowner,
  $oracle_install_user_name = $io_weblogic::oracle_install_user_name,
) inherits io_weblogic{

  $security_dir = "${java_home}/jre/lib/security"

  archive { '/oracle_jce.zip' :
    ensure          => $ensure,
    user            => $fileowner,
    group           => $oracle_install_user_name,
    extract         => true,
    source          => $jce_archive_path,
    cookie          => 'oraclelicense=accept-securebackup-cookie',
    extract_path    => $security_dir,
    extract_command => "${extract_command}${security_dir}",
    creates         => "${security_dir}/README.txt",
    cleanup         => true,
  }
}
