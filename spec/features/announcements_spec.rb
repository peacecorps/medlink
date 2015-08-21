require 'spec_helper'

describe "Announcements" do
  before :each do
    @pcmo = create :pcmo
    @old  = create :announcement, \
      message: "Old news", last_sent_at: 1.week.ago, country: @pcmo.country
    @new  = create :announcement, \
      message: "New news", last_sent_at: 10.minutes.ago, country: @pcmo.country
    @other = create :announcement, message: "For different country"

    @pcv = create :pcv, country: @pcmo.country
    create :phone, user: @pcv
  end

  def send_button_for announcement
    find("tr", text: announcement.message).find("a", text: "Send Now")
  end

  it "allows PCMOs to send messages on demand" do
    login @pcmo
    visit announcements_path

    click_on "New Announcement"
    within ".new_announcement" do
      fill_in "Message", with: "Special message from your PCMO"
      click_on "Create Announcement"
    end

    expect( send_button_for @old ).not_to be_disabled
    expect( send_button_for @new ).to be_disabled

    newer = Announcement.last
    expect( send_button_for newer ).not_to be_disabled

    expect( page ).not_to have_content "For different country"

    send_button_for(@old).click
    send_button_for(newer).click

    expect( send_button_for newer ).to be_disabled
    expect( @pcv.messages.pluck :text ).to eq ["Special message from your PCMO", "Old news"]
  end

  it "allows admins to schedule message for recurring sending" do
    admin = create :admin
    login admin
    visit announcements_path

    expect( page ).to have_content "Old news"
    expect( page ).to have_content "For different country"

    click_on "New Announcement"
    within ".new_announcement" do
      select @other.country.name, from: "Country"
      fill_in "Days", with: " 2, -2 "
      select "07", from: "Hour"
      click_on "Create Announcement"
    end

    expect( page ).to have_content "can't be blank"

    within ".new_announcement" do
      fill_in "Message", with: "Monthly reminder"
      click_on "Create Announcement"
    end

    announcement = Announcement.last
    expect( announcement.message ).to eq "Monthly reminder"
    expect( announcement.schedule.days ).to eq [2,-2]
    expect( announcement.schedule.hour ).to eq 7

    find("tr", text: "Monthly reminder").find("a", text: "Edit").click

    within ".edit_announcement" do
      fill_in "Message", with: ""
      fill_in "Days", with: ""
      select "", from: "Hour"
      click_on "Update Announcement"
    end

    expect( page ).to have_content "can't be blank"

    within ".edit_announcement" do
      fill_in "Message", with: "Updated monthly reminder"
      fill_in "Days", with: ""
      select "", from: "Hour"
      click_on "Update Announcement"
    end

    announcement.reload
    expect( announcement.message ).to eq "Updated monthly reminder"
    expect( announcement.schedule.days ).to eq []
    expect( announcement.schedule.hour ).not_to be_present
  end
end
