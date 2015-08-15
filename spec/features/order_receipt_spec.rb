require "spec_helper"

describe "recording receipt" do
  before :each do
    @user = create :user
    2.times do
      request = create :request, user: @user
      2.times do
        create :order, request: request, user: @user
      end
    end
    @old, @new = @user.requests.to_a

    @r1 = create :response, user: @user
    (@old.orders.to_a + [@new.orders.last]).each { |o| o.update! response: @r1 }

    @r2 = create :response, user: @user
    @new.orders.first.update! response: @r2

    login @user
  end

  def approve_button supply
    row = find('.response tr', text: supply.name)
    row.find("a[title='Mark as received']")
  end

  it "lets users mark individual supplies as receieved" do
    visit orders_path

    sup = @new.supplies.first

    approve = approve_button sup
    expect( approve[:class] ).to eq "btn btn-default"
    approve.click

    expect( approve_button(sup)[:class] ).to eq "btn btn-success"
    expect( approve_button(@new.supplies.last)[:class] ).to eq "btn btn-default"
  end

  it "lets users mark entire requests as received" do
    visit orders_path

    all("a[title='Mark all as received']").first.click

    @r2.supplies.each do |supply|
      expect( approve_button(supply)[:class] ).to eq "btn btn-success"
    end
    @r1.supplies.each do |supply|
      expect( approve_button(supply)[:class] ).to eq "btn btn-default"
    end
  end

  it "archives responses when they have been received" do
    visit orders_path
    @r2.supplies.each do |supply|
      approve_button(supply).click
    end
    [@r1,@r2].each &:reload

    expect( @r1 ).not_to be_archived
    expect( @r2 ).to be_archived

    all("a[title='Mark all as received']").last.click
    @r1.reload
    expect( @r1 ).to be_archived
  end

  it "allows users to flag orders" do
    visit orders_path

    all("a[title='Flag all for follow-up']").first.click
    all("a[title='Flag for follow-up']").last.click

    flag_buttons = all("a[title='Flag for follow-up']")
    expect( flag_buttons.count ).to eq 4
    expect( flag_buttons.count { |a| a[:class].include? "btn-danger" } ).to eq 2
    expect( flag_buttons.count { |a| a[:class].include? "btn-default" } ).to eq 2
  end

  describe "via sms" do
    before :each do
      @old.orders.each &:mark_received!
    end

    it "allows users to approve all outstanding via sms" do
      response = send_text @user, "ok"

      expect( response.text ).to match /marked as received/i
      @new.supplies.each do |supply|
        expect( response.text ).to include supply.name
      end
      expect( @user.orders.select(&:received?).count ).to eq 4
      expect( @user.orders.select(&:flagged?).count  ).to eq 0
    end

    it "allows users to flag all outstanding via sms" do
      response = send_text @user, "no"

      expect( response.text ).to match /flagged for follow-up/i
      @new.supplies.each do |supply|
        expect( response.text ).to include supply.name
      end
      expect( @user.orders.select(&:received?).count ).to eq 2
      expect( @user.orders.select(&:flagged?).count  ).to eq 2
    end

    it "notifies if there are no outstanding orders", :no_bullet do
      @user.orders.each &:mark_received!

      response = send_text @user, "flag"
      expect( response.text ).to match /can't find any outstanding orders/i
      expect( @user.orders.select(&:flagged?).count ).to eq 0
    end
  end
end
