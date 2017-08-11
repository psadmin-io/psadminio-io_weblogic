require 'spec_helper'

describe('io_weblogic::java_options', :type => :class) do
  let(:default_params) do
    {
      :pia_domain_name => 'hcmdmo',
      :settings        => {'Xmx' => '1024m' },
    }
  end

  context 'when called with parameters on Linux' do
    let(:facts) { { :os => {'name' => 'Linux'} } }

    let :params do
      default_params.merge({
        :ps_config_home  => '/tmp/ps_cfg_home/hcmdmo',
      })
    end

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_ini_subsetting("hcmdmo WLS JAVA_OPTIONS_LINUX, Xmx, 1024m")
      .with({
        'path'                 => '/tmp/ps_cfg_home/hcmdmo/webserv/hcmdmo/bin/setEnv.sh',
        'setting'              => 'JAVA_OPTIONS_LINUX',
        'subsetting_separator' => ' -',
        'subsetting'           => 'Xmx',
        'value'                => '1024m',
      })
    }
  end

  context 'when called with parameters on Windows' do
    let(:facts) { { :os => {'name' => 'windows'} } }

    let :params do
      default_params.merge({
        :ps_config_home => 'C:\temp\ps_cfg_home\hcmdmo',
      })
    end

    it { is_expected.to contain_ini_subsetting("hcmdmo WLS JAVA_OPTIONS_WIN, Xmx, 1024m")
      .with({
        'path'                 => 'C:\\temp\\ps_cfg_home\\hcmdmo\\webserv\\hcmdmo\\bin\\setEnv.cmd',
        'setting'              => 'JAVA_OPTIONS_WIN',
        'subsetting_separator' => ' -',
        'subsetting'           => 'Xmx',
        'value'                => '1024m',
      })
    }
  end
end
