require 'spec_helper'
describe 'kubernetes' do

  context 'with defaults for all parameters' do
      let :params do {
       :master_name => '1.1.1.1', 
       :minion_name => '1.1.1.1', 
      } end
    # should not compile as should not be called
    it { should_not compile }
  end
end
