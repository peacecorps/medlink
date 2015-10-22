require "spec_helper"

describe "sending receipt reminders" do
  before :each do
    @past = DateTime.parse("October 26, 1985 01:20")
    Timecop.freeze @past
    @response = create :response
    @user     = @response.user
    create :phone, user: @response.user
  end
  after :each do
    Timecop.return
  end

  def advance day_count
    stop = day_count.days.from_now
    while Time.now < stop
      Response.send_receipt_reminders!
      Timecop.freeze Time.now + 1.hour
    end
    @response.reload
  end

  it "reminds 3 times over several weeks" do
    advance 15
    expect( @response.receipt_reminders.count ).to eq 1

    advance 3
    expect( @response.receipt_reminders.count ).to eq 2

    advance 3
    expect( @response.receipt_reminders.count ).to eq 3
    expect( @response ).not_to be_flagged

    advance 3
    expect( @response.receipt_reminders.count ).to eq 3
    expect( @response ).to be_flagged
  end

  it "won't follow up once response is acknowledged" do
    advance 15
    expect( @response.receipt_reminders.count ).to eq 1

    advance 3
    expect( @response.receipt_reminders.count ).to eq 2
    @user.make_sms_request "yes"
    expect( @response.reload ).to be_received

    advance 6
    expect( @response.receipt_reminders.count ).to eq 2
    expect( @response ).not_to be_flagged
  end

  it "won't follow up if a response is flagged" do
    advance 15
    @user.make_sms_request "no"
    expect( @response.reload ).to be_flagged

    advance 20
    expect( @response.receipt_reminders.count ).to eq 1
  end
end
