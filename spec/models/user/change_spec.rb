require 'spec_helper'

describe User::Change do
  before :each do
    @user = create :user
    @_old = @user.attributes
  end

  it "displays foreign-key updates correctly" do
    @user.update_attributes country: create(:country)

    ∆ = User::Change.new @_old, @user
    expect( ∆.summary ).to eq "country=[#{@user.country.name}]"
  end
end
