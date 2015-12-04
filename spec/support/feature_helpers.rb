module FeatureHelpers
  def screenshot path=nil
    path ||= "#{ENV['HOME']}/Desktop/screenshot.png"
    page.save_screenshot path, full: true
  end

  def logout
    page.driver.browser.clear_cookies
  end

  def login_as user
    logout
    visit root_path
    within ".sign-in" do
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_on "Sign In"
    end
  end

  def flash
    page.find ".flash"
  end

  def s
    save_and_open_page
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
