require 'spec_helper'

describe PasswordsController do
  render_views

  before(:each) do
    request.env['devise.mapping'] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
  end

  describe "POST create" do
    it "with valid email/pcvid combo", :worker do
      old_token = @user.reset_password_token
      post :create, :user => { "email" => @user.email,
        "pcv_id" => @user.pcv_id }
      expect(User.find(@user.id).reset_password_token).to_not eq(old_token)
      expect( response ).to redirect_to new_user_session_path
    end

    it "with invalid email/pcvid combo" do
      post :create, :user => { "email" => @user.email, "pcv_id" => "123" }
      flash[:error].should_not be_nil
      expect( response ).to be_redirection
    end
  end
end
