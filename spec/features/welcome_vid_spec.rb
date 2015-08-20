require 'spec_helper'

describe "Welcome Vid page" do
  def test_sign_in user
    visit new_user_session_path
    within ".sign-in" do
      fill_in "user_email", with: user.email
      fill_in "user_password", with: "password"
      click_on "Sign In"
    end
  end

  it 'redirects users who access the video path but are not logged in' do
    visit welcome_video_user_path
    expect( page.current_path ).to eq new_user_session_path
  end

  it 'shows users who have not seen the video the video page immediately upon login' do
    user = create :user, password: "password", welcome_video_shown_at: nil
    test_sign_in user
    expect( page.current_path ).to eq welcome_video_user_path
  end

  it 'directs users who have seen the video immediately to the root path' do
    user = create :user, password: "password"
    test_sign_in user
    expect( page.current_path ).to eq welcome_video_user_path
    page.click_button("watched")
    expect( user.reload.welcome_video_shown_at ).not_to be nil

    click_link "Sign Out"
    test_sign_in user
    expect( page.current_path ).to eq new_request_path
  end

  it "shows PCMOs a different video" do
    pcmo = create :pcmo, password: "password"
    test_sign_in pcmo

    src = pcmo.welcome_video.youtube_embed_link
    expect( page.find("iframe")[:src] ).to eq src
    expect( src ).not_to eq build(:pcv).welcome_video.youtube_embed_link
  end
end
