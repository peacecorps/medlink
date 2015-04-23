require 'spec_helper'

describe "Welcome Vid page" do
  it 'redirects users who access the video path but are not logged in' do
    visit welcome_video_user_path
    expect( page.current_path ).to eq new_user_session_path
  end

  it 'shows users who have not seen the video the video page immediately upon login' do
    user = create :user, password: "password", welcome_video_shown_at: nil
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "password"
    click_on "Sign In"
    expect( page.current_path ).to eq welcome_video_user_path
  end

  it 'directs users who have seen the video immediately to the root path' do
    user = create :user, password: "password" 
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "password"
    click_on "Sign In"
    expect( page.current_path ).to eq welcome_video_user_path
    page.click_button('watched')
    user.reload
    expect( user.welcome_video_shown_at.nil?).to eq false
  end
end