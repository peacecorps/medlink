require 'spec_helper'

describe User do
  subject { FactoryGirl.create :user, pcv_id: 'USR' }

  it 'can be created' do
    expect( subject ).to be_a_kind_of User
  end
  context "accessible_orders" do
    describe "for non-admin users" do
      subject { FactoryGirl.create(:user) }
      before do
        @unowned_orders = FactoryGirl.create_list(:order, 10)
        @orders = FactoryGirl.create_list(:order, 10, user_id: subject.id)
      end
      it 'should only show their own orders' do
        owned_ids = @orders.map(&:id).uniq.sort
        expect( subject.accessible_orders.map(&:id).uniq.sort ).to eq owned_ids
      end

    end
    describe "for admin users" do
      subject { FactoryGirl.create(:admin) }
      let (:managed_user1) { 
        FactoryGirl.create(:user, country_id: subject.country_id) 
      }
      let (:managed_user2) { 
        FactoryGirl.create(:user, country_id: subject.country_id) 
      }
      before do
        @orders1 = FactoryGirl.create_list(:order, 10, user_id: managed_user1.id)
        @orders2 = FactoryGirl.create_list(:order, 10, user_id: managed_user2.id)
      end
      it 'should show orders for the admins whole country' do
        combined_ids = @orders1.map(&:id) + @orders2.map(&:id)
        combined_ids.sort! and combined_ids.uniq!
        expect( subject.accessible_orders.map(&:id).uniq.sort ).to eq combined_ids
      end
    end
  end

  context 'lookup' do
    before(:each) { FactoryGirl.create :user, pcv_id: 'USR' }
  
    it 'retrieves upper case' do
      expect( User.lookup 'USR' ).to be_present
    end

    it 'retrieves lower case' do
      expect( User.lookup 'usr' ).to be_present
    end
  end
end
