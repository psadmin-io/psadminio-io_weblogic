class io_weblogic::jce (
  $ensure                   = $io_weblogic::ensure,
  $jce_path                 = $io_weblogic::jce_path,
  $java_home                = $io_weblogic::java_home,
  $extract_command          = $io_weblogic::extract_command,
  $fileowner                = $io_weblogic::fileowner,
  $oracle_install_user_name = $io_weblogic::oracle_install_user_name,
  $tools_version            = $io_weblogic::tools_version,
) {

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
