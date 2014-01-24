require 'spec_helper'
require 'ostruct'

RSpec.configure do |c|
  # declare an exclusion filter
  c.filter_run_excluding :list
end

describe SMS do

  describe "request with dosage" do

    context "succeeds with comma-space delimiter" do
      data = {
          :From => '+15555555555',
          :Body => '111111, aceta, 30mg, 50, ACCRA'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'aceta' }
      its( :qty )          { should eq '50' }
      its( :loc )          { should eq 'ACCRA' }
      its( :dosage_value ) { should eq '30' }
      its( :dosage_dose  ) { should eq 'mg' }
    end

    context "succeeds with comma delimiter" do
      data = {
          :From => '+15555555555',
          :Body => '111111,aceta,30mg,50,ACCRA'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'aceta' }
      its( :qty )          { should eq '50' }
      its( :loc )          { should eq 'ACCRA' }
      its( :dosage_value ) { should eq '30' }
      its( :dosage_dose  ) { should eq 'mg' }
    end

    context "succeeds with comma delim and dosage value/dose are spaced" do
      data = {
          :From => '+15555555555',
          :Body => '111111,aceta,30 mg,50,ACCRA'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'aceta' }
      its( :qty )          { should eq '50' }
      its( :loc )          { should eq 'ACCRA' }
      its( :dosage_value ) { should eq '30' }
      its( :dosage_dose  ) { should eq 'mg' }
    end

    context "succeeds w/ comma-space delim and dosage value/dose are spaced" do
      data = {
          :From => '+15555555555',
          :Body => '111111, aceta, 30 mg, 50, ACCRA'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'aceta' }
      its( :qty )          { should eq '50' }
      its( :loc )          { should eq 'ACCRA' }
      its( :dosage_value ) { should eq '30' }
      its( :dosage_dose  ) { should eq 'mg' }
    end

    it "fails with single-space delimiter" do
      data = {
          :From => '+15555555555',
          :Body => '111111 aceta 30mg 50 ACCRA'
        }
      expect{ SMS.parse data }.to raise_error SMS::ParseError
    end

  end

  describe "request without dosage" do

    context "succeeds with comma-space delimiter" do
      data = {
        :From => '+15555555555',
        :Body => '111111, bandg, 50, ACCRA'
      }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'bandg' }
      its( :qty )          { should eq '50' }
      its( :loc )          { should eq 'ACCRA' }
    end

    context "succeeds with comma delimiter" do
      data = {
          :From => '+15555555555',
          :Body => '111111,bandg,50,ACCRA'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'bandg' }
      its( :qty )          { should eq '50' }
      its( :loc )          { should eq 'ACCRA' }
    end

    it "fails with single-space delimiter" do
      data = {
        :From => '+15555555555',
        :Body => '111111 bandg 50 ACCRA'
      }
      expect{ SMS.parse data }.to raise_error SMS::ParseError
    end

  end

  describe "list requests" do

    context "can process list request", :list do
      data = {
          :From => '+15555555555',
          :Body => 'list?'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :to )   { should eq '+15555555555' }
      its( :body ) { should eq 'meds, dose, country' }
    end

    context "can process list dose", :list do
      data = {
          :From => '+15555555555',
          :Body => 'list dose'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :to )   { should eq '+15555555555' }
      its( :body ) { should eq 'mg, g, ml' }
    end

    context "can process list country", :list do
      data = {
          :From => '+15555555555',
          :Body => 'list ghana'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :to )   { should eq '+15555555555' }
      its( :body ) { should eq 'one, two, three' }
    end

  end
end
