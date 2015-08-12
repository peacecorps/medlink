require 'spec_helper'

describe "Bulk texting" do
  describe "as an admin" do
    before :each do
      3.times do
        country = create :country
        user = create :user, country: country
        create :phone, user: user
      end

      @countries = Country.last 2

      @user = create :admin
      login @user

      visit new_message_path
    end

    it "can send to multiple countries" do
      fill_in "message_sender_body", with: "Test message"
      @countries.each do |c|
        select c.name, from: "message_sender_country_ids"
      end
      click_button "Send"

      expect( page ).to have_content "Test message"
      expect( page ).to have_content "2 users"
      expect( page ).to have_css "#message_sender_country_ids"

      expect( Phone.count ).to be > 2
      expect( SMS.outgoing.count ).to eq 2
      expect( SMS.outgoing.pluck(:text).uniq ).to eq ["Test message"]

      user_numbers = User.
        where(country: @countries).includes(:phones).
        map { |u| u.primary_phone.number }
      expect( user_numbers.sort ).to eq SMS.outgoing.pluck(:number).sort
    end

    it "validates a message" do
      @countries.each do |c|
        select c.name, from: "message_sender_country_ids"
      end
      click_button "Send"

      expect( page ).not_to have_content "Test message"
      expect( page ).to have_content "No message"

      expect( SMS.outgoing.count ).to eq 0
    end
  end

  describe "as a pcmo" do
    before :each do
      country = create :country
      3.times do
        user = create :user, country: country
        create :phone, user: user
      end

      @user = create :pcmo, country: country
      create :phone, user: @user
      login @user

      visit new_message_path
    end

    it "can send messages to that country" do
      fill_in "message_sender_body", with: "PCMO message"
      click_button "Send"

      expect( page ).to have_content "PCMO message"
      expect( page ).to have_content "4 users"

      expect( SMS.outgoing.pluck :text ).to eq(["PCMO message"] * 4)
    end

    it "can only send messages to that country" do
      expect( page ).not_to have_css "#message_sender_country_ids"
    end
  end
end
