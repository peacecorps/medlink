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
    expect( recorded.number ).to eq Phone.condense(captured.number)
    expect( recorded.number ).to eq Phone.condense(phone.number)

    recorded
  end

  it "responds to the right phone" do
    3.times { create :phone, user: @user }
    new_phone = @user.phones.last

    expect( @user.primary_phone ).not_to eq new_phone

    resp = response_for new_phone, "help"
    expect( resp.number ).to eq Phone.condense(new_phone.number)
  end

  it "handles unknown phones" do
    phone = Phone.new number: "+11234561234"
    resp = response_for phone, "#{@supply.shortcode} - ?"

    expect( resp.number ).to eq phone.number
    expect( resp.text ).to match /can't find user account/i
  end

  it "can look up users by pcv id" do
    new_phone = create :phone
    expect( new_phone.user ).not_to eq @user

    resp = response_for @phone, "@#{@user.pcv_id} #{@supply.shortcode}"

    expect( resp.user ).to eq @user
    expect( SMS.incoming.last.user ).to eq @user
    expect( Request.last.user ).to eq @user
  end

  it "responds with a help message when the text is malformed" do
    resp = response_for @phone, "jansldk ajanlskjd alskjdnfal kajndsflj"
    expect( resp.text ).to match /unrecognized.*jansldk.*3.other.*resubmit.*format/i
    expect( Request.count ).to eq 0
  end

  it "responds with a help message when the user cannot be determined" do
    resp = response_for @phone, "@XXXX #{@supply.shortcode}"
    expect( resp.text ).to match /can't find user/i

    strange_phone = create :phone, user: nil
    resp = response_for strange_phone, "#{@supply.shortcode}"
    expect( resp.text ).to match /can't find user/i
  end
end
