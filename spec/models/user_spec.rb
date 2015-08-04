require 'spec_helper'

describe User do
  subject { create :user, pcv_id: 'USR' }

  its(:pcv_id) { should eq 'USR' }

  context 'admin relations' do
    before :all do
      @us      = create :country, name: "USA"
      @senegal = create :country, name: "Senegal"

      @admin = create :admin, country: @us

      @p = create :pcmo, country: @us
      @q = create :pcmo, country: @us
      @r = create :pcmo, country: @senegal

      # TODO: validate pcmo for pcvs? Country match?
      @a = create :pcv, country: @us
      @b = create :pcv, country: @us
      @c = create :pcv, country: @senegal
    end
  end

  context 'lookup' do
    before(:each) { create :user, pcv_id: 'USR' }

    it 'retrieves upper case' do
      expect( User.find_by_pcv_id 'USR' ).to be_present
    end

    it 'retrieves lower case' do
      expect( User.find_by_pcv_id 'usr' ).to be_present
    end
  end

  context 'can send reset instructions' do
    before(:each) { ActionMailer::Base.deliveries = [] }

    it 'asyncronously', :worker do
      subject.send_reset_password_instructions
      expect( ActionMailer::Base.deliveries.count ).to eq 1
    end
  end

  it 'generates different video links for pcmos and pcvs' do
    pcmo = create :pcmo
    pcv = create :pcv
    expect( pcmo.welcome_video ).not_to eq pcv.welcome_video

    #check neither is nil
  end
end
