require 'spec_helper'
require 'ostruct'

describe SMS do

  describe "request with dosage" do

    context "succeeds with comma-space delimiter" do
      data = {
          :From => '+15555555555',
          :Body => '111111, aceta, ACCRA'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'aceta' }
      its( :loc )          { should eq 'ACCRA' }
    end

    context "succeeds with comma delimiter" do
      data = {
          :From => '+15555555555',
          :Body => '111111,aceta,ACCRA'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'aceta' }
      its( :loc )          { should eq 'ACCRA' }
    end

    context "succeeds with comma delim" do
      data = {
          :From => '+15555555555',
          :Body => '111111,aceta,ACCRA'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'aceta' }
      its( :loc )          { should eq 'ACCRA' }
    end

    context "succeeds w/ comma-space delim and spaced" do
      data = {
          :From => '+15555555555',
          :Body => '111111, aceta, ACCRA'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'aceta' }
      its( :loc )          { should eq 'ACCRA' }
    end

    it "fails with single-space delimiter" do
      data = {
          :From => '+15555555555',
          :Body => '111111 aceta ACCRA'
        }
      expect{ SMS.parse data }.to raise_error SMS::ParseError
    end

  end

  describe "request without dosage" do

    context "succeeds with comma-space delimiter" do
      data = {
        :From => '+15555555555',
        :Body => '111111, bandg, ACCRA'
      }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'bandg' }
      its( :loc )          { should eq 'ACCRA' }
    end

    context "succeeds with comma delimiter" do
      data = {
          :From => '+15555555555',
          :Body => '111111,bandg,ACCRA'
        }
      subject { OpenStruct.new SMS.parse data }

      its( :phone )        { should eq '+15555555555' }
      its( :pcvid )        { should eq '111111' }
      its( :shortcode )    { should eq 'bandg' }
      its( :loc )          { should eq 'ACCRA' }
    end

    it "fails with single-space delimiter" do
      data = {
        :From => '+15555555555',
        :Body => '111111 bandg ACCRA'
      }
      expect{ SMS.parse data }.to raise_error SMS::ParseError
    end

  end
end
