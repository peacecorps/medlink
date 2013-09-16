require 'spec_helper'

describe User do
  subject { FactoryGirl.create :user, pcv_id: 'USR' }

  it 'can be created' do
    expect( subject ).to be_a_kind_of User
  end

  its(:name) { should match /user\d+ user\d+last/ }

  context "accessible_orders" do
    describe "for non-admin users" do
      subject { FactoryGirl.create(:user) }
      before do
        @unowned_orders = FactoryGirl.create_list(:order, 10, location: 'Unowned Loc')
        @orders = FactoryGirl.create_list(:order, 10, user_id: subject.id, location: 'orders Loc')
      end
      it 'should only show their own orders' do
        owned_ids = @orders.map(&:id).uniq.sort
        expect( subject.accessible_orders.map(&:id).uniq.sort
          ).to eq owned_ids
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
        @orders1 = FactoryGirl.create_list(:order, 10,
          user_id: managed_user1.id, location: 'user loc 1')
        @orders2 = FactoryGirl.create_list(:order, 10,
          user_id: managed_user2.id, location: 'Loc 2')
      end
      it 'should show orders for the admins whole country' do
        combined_ids = @orders1.map(&:id) + @orders2.map(&:id)
        combined_ids.sort! and combined_ids.uniq!
        expect( subject.accessible_orders.map(&:id).uniq.sort
          ).to eq combined_ids
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

  context 'can send reset instructions' do
    before(:each) { ActionMailer::Base.deliveries = [] }

    it 'asyncronously', :worker do
      MailerJob.should_receive(:enqueue).with(:forgotten_password,
        subject.id).and_call_original
      subject.send_reset_password_instructions
      expect( ActionMailer::Base ).to have_exactly(1).deliveries
    end

    it 'syncronously' do
      MailerJob.should_not_receive(:enqueue).with(:forgotten_password,
        subject.id)
      subject.send_reset_password_instructions async: false
      expect( ActionMailer::Base ).to have_exactly(1).deliveries
    end
  end
end
