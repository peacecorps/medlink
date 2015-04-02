require 'spec_helper'

describe User do
  subject { create :user, pcv_id: 'USR' }

  its(:pcv_id) { should eq 'USR' }

  # TODO: these are order specs. Extract.
  context "accessible_orders" do
    describe "for non-admin users" do
      subject { create(:user) }
      before do
        @unowned_orders = create_list(:order, 10)
        @orders = create_list(:order, 10,
          user_id: subject.id)
      end
      it 'should only show their own orders' do
        owned_ids = @orders.map(&:id).uniq.sort
        expect( subject.accessible(Order).map(&:id).uniq.sort
          ).to eq owned_ids
      end

    end
    describe "for admin users" do
      subject { create(:admin) }
      let (:managed_user1) {
        create(:user, country_id: subject.country_id)
      }
      let (:managed_user2) {
        create(:user, country_id: subject.country_id)
      }
      before do
        @orders1 = create_list(:order, 10,
          user_id: managed_user1.id)
        @orders2 = create_list(:order, 10,
          user_id: managed_user2.id)
      end
      it 'should show orders for the admins whole country' do
        combined_ids = @orders1.map(&:id) + @orders2.map(&:id)
        combined_ids.sort! and combined_ids.uniq!
        expect( subject.accessible(Order).map(&:id).uniq.sort
          ).to eq combined_ids
      end
    end
  end

  context 'admin relations' do
    before :all do
      @us      = create :country, name: "USA"
      @senegal = create :country, name: "Senegal"

      @admin = create :admin, country: @us

      @p = create :pcmo, country: @us
      @q = create :pcmo, country: @us
      @r = create :pcmo, country: @senegal

      # TODO: validate pcmo for pcvs? Country match?
      @a = create :pcv, country: @us
      @b = create :pcv, country: @us
      @c = create :pcv, country: @senegal
    end
  end

  context 'lookup' do
    before(:each) { create :user, pcv_id: 'USR' }

    it 'retrieves upper case' do
      expect( User.find_by_pcv_id 'USR' ).to be_present
    end

    it 'retrieves lower case' do
      expect( User.find_by_pcv_id 'usr' ).to be_present
    end
  end

  context 'can send reset instructions' do
    before(:each) { ActionMailer::Base.deliveries = [] }

    it 'asyncronously', :worker do
      subject.send_reset_password_instructions
      expect( ActionMailer::Base.deliveries.count ).to eq 1
    end
  end

  it "raises when authorizing a user without a role" do
    expect do
      Ability.new(subject).can? :create, Order
    end.not_to raise_error
    expect do
      Ability.new(User.new).can? :create, Order
    end.to raise_error /unknown role/i
  end
end
