require 'spec_helper'
require 'ostruct'

describe SMS do

  context "can process request with dosage" do  
    data = {
        :From => '+15555555555',
        :Body => '111111 bandg 30mg 50 ACCRA'
      }	
  	subject { OpenStruct.new SMS.parse(data).data }

  	its( :phone )        { should eq '+15555555555' }
  	its( :pcvid )        { should eq '111111' }
  	its( :shortcode )    { should eq  'bandg' }
  	its( :qty )          { should eq '50' }
  	its( :loc )          { should eq 'ACCRA' }
  	its( :dosage_value ) { should eq '30' }
  	its( :dosage_units ) { should eq 'mg' }
  end

  context "can process list request" do  
    data = {
        :From => '+15555555555',
        :Body => 'list?'
      } 
    subject { OpenStruct.new SMS.parse(data).data }

    its( :to )   { should eq '+15555555555' }
    its( :body ) { should eq 'meds, units, country' }
  end

  context "can process list units" do  
    data = {
        :From => '+15555555555',
        :Body => 'list units'
      } 
    subject { OpenStruct.new SMS.parse(data).data }

    its( :to )   { should eq '+15555555555' }
    its( :body ) { should eq 'mg, g, ml' }
  end

end