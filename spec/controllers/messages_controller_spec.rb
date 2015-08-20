require 'spec_helper'

describe MessagesController do
  it "disallows PCVs" do
    pcv = create :pcv
    login pcv
    post :create, message_sender: { body: "hax", country_id: [pcv.country_id] }
    expect( response.redirect_url ).to include new_user_session_path
    expect( SMS.count ).to eq 0
  end
end
