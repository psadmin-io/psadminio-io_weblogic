require 'spec_helper'
describe 'io_weblogic' do

  context 'with defaults for all parameters' do
    it { should contain_class('io_weblogic') }
  end
end
