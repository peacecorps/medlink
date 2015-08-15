require "spec_helper"

# Note: these tests are really about the SMSOrderPlacer, but are ported straight from
#   before there was anything to dispatch to
describe SMSDispatcher do
  before :each do
    @phone  = create :phone
    @user   = @phone.user
    @supply = create :supply

    @user.country.supplies << @supply
  end

  def response_for phone, text
    t = create :twilio_account
    r = SMSDispatcher.new(account_sid: t.sid, from: phone.number, to: t.number, body: text)
    r.record_and_respond

    recorded = SMS.outgoing.last
    captured = messages.last

    expect( recorded.text ).to eq captured.body
    expect( recorded.number.gsub /\D/, '' ).to include captured.number
    expect( recorded.number ).to eq phone.number

    recorded
  end

  it "creates a request for well-formed texts" do
    incoming = "#{@supply.shortcode} - please and thank you!"
    resp = response_for @phone, incoming

    req = Request.last
    expect( req.user ).to eq @user
    expect( req.message.text ).to eq incoming
    expect( req.supplies ).to eq [@supply]
    expect( req.text ).to eq "please and thank you!"

    expect( resp.user ).to eq @user
    expect( resp.text ).to match /#{@supply.name} \(#{@supply.shortcode}\)/
    expect( resp.text ).to match /expect a response/i
  end

  it "responds to the right phone" do
    3.times { create :phone, user: @user }
    new_phone = @user.phones.last

    expect( @user.primary_phone ).not_to eq new_phone

    resp = response_for new_phone, "help"
    expect( resp.number ).to eq new_phone.number
  end

  it "handles unknown phones" do
    phone = Phone.new number: "+11234561234"
    resp = response_for phone, "#{@supply.shortcode} - ?"

    expect( resp.number ).to eq phone.number
    expect( resp.text ).to match /can't find user account/i
  end

  it "does not create requests for duplicate responses" do
    msg = "#{@supply.shortcode} - please and thank you!"

    expect { response_for @phone, msg }.to change { Request.count }.by(1)
    expect { @response = response_for(@phone, msg) }.not_to change { Request.count }

    expect( @response.text ).to match /already received your request/i
  end

  it "can look up users by pcv id" do
    new_phone = create :phone
    expect( new_phone.user ).not_to eq @user

    resp = response_for @phone, "@#{@user.pcv_id} #{@supply.shortcode}"

    expect( resp.user ).to eq @user
    expect( SMS.incoming.last.user ).to eq @user
    expect( Request.last.user ).to eq @user
  end

  it "responds with a help message when the user cannot be determined" do
    resp = response_for @phone, "@XXXX #{@supply.shortcode}"
    expect( resp.text ).to match /can't find user/i

    strange_phone = create :phone, user: nil
    resp = response_for strange_phone, "#{@supply.shortcode}"
    expect( resp.text ).to match /can't find user/i
  end

  it "responds with a help message when the supplies cannot be determined" do
    resp = response_for @phone, "ZXCV, ASDF"
    expect( resp.text ).to match /unrecognized supply short codes: ZXCV and ASDF/i
  end

  it "can abridge the confirmation message if it's too long" do
    n = 12
    n.times { @user.country.supplies << create(:supply) }

    msg = response_for @phone, Supply.last(n).map(&:shortcode).join(' ')

    expect( msg.text.length ).to be < 160
    expect( msg.text ).to match /#{n - 1} other/
  end
end
