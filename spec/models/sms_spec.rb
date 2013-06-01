require 'spec_helper'

describe SMS do
	before do
		data = {
  			:From => '+15555555555',
  			:Body => '111111 bandg 30mg 50 ACCRA'
  		}
	end

  context "can parse Twilio POST data" do  	
  	subject { SMS.parse data }

  	it { should be_a_kind_of SMS }

  	its( data[:phone] )        { should eq '+15555555555' }
  	its( data[:pcvid] )        { should eq '111111' }
  	its( data[:shortcode] )    { should eq  'bandg' }
  	its( data[:qty] )          { should eq '50' }
  	its( data[:loc] )          { should eq 'ACCRA' }
  	its( data[:dosage_value] ) { should eq '30' }
  	its( data[:dosage_units] ) { should eq 'mg' }
  end
end