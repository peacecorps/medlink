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

  def received_button response
    find("#response-#{response.id} a[title='Mark as received']")
  end
  def flag_button response
    find("#response-#{response.id} a[title='Flag for follow-up']")
  end

  it "lets users mark entire requests as received" do
    visit orders_path

    received_button(@r2).click

    expect( received_button(@r2)[:class] ).to eq "btn btn-success"
    expect( flag_button(@r2)[:disabled] ).to eq "disabled"

    expect( @r2.reload ).to be_received
    expect( @r1.reload ).not_to be_received
  end

  it "allows users to flag orders" do
    visit orders_path

    flag_button(@r1).click

    expect( flag_button(@r1)[:class] ).to eq "btn btn-danger"

    expect( @r1.reload ).to be_flagged
    expect( @r2.reload ).not_to be_flagged
  end

  it "unflags things as they are received" do
    visit orders_path

    flag_button(@r1).click
    received_button(@r1).click

    expect( @r1.reload ).not_to be_flagged
    expect( @r1 ).to be_received
  end

  describe "via sms" do
    before :each do
      @r1.mark_received!
    end

    it "allows users to approve all outstanding via sms" do
      response = send_text @user, "ok"

      expect( response.text ).to match /marked as received/i
      @r2.supplies.each do |supply|
        expect( response.text ).to include supply.name
      end
      expect( @user.responses.select(&:received?).count ).to eq 2
    end

    it "allows users to flag all outstanding via sms" do
      response = send_text @user, "no"

      expect( response.text ).to match /flagged for follow-up/i
      @r2.supplies.each do |supply|
        expect( response.text ).to include supply.name
      end
      expect( @user.responses.select(&:received?).count ).to eq 1
      expect( @user.responses.select(&:flagged?).count  ).to eq 1
    end

    it "notifies if there are no outstanding orders", :no_bullet do
      @user.responses.each &:mark_received!

      response = send_text @user, "flag"
      expect( response.text ).to match /can't find any outstanding orders/i
      expect( @user.responses.select(&:flagged?).count ).to eq 0
    end
  end
end
