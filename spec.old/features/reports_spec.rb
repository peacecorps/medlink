require 'spec_helper'

# TODO: extract reports into CSV objects. What about the view date helper?
describe ReportsController do

  before :all do
    c = create :country
    @user = create :user, country: c

    create :order, user: @user, created_at: 2.months.ago

    response = create :response, user: @user
    create :order,
      created_at:      3.days.ago,
      response:        response,
      delivery_method: DeliveryMethod::Purchase

    @pcmo = create :pcmo, country: c
    @admin = create :admin
  end

  describe "as a PCV" do
    before(:each) { login @user }

    it "can't see reports" do
      visit reports_path
      expect( page ).to have_content "not authorized"
    end
  end

  describe "as a PCMO" do
    before(:each) { login @pcmo }

    it "can see partial order history" do
      visit order_history_reports_path(format: :csv)
      expect( page.html.lines.count ).to eq 2
    end

    it "can't see user reports" do
      visit users_reports_path(format: :csv)
      expect( page ).to have_content "not authorized"
    end

    it "can't see response time reports" do
      visit pcmo_response_times_reports_path(format: :csv)
      expect( page ).to have_content "not authorized"
    end
  end

  describe "as an admin" do
    before(:each) { login @admin }

    it "can see all orders" do
      visit order_history_reports_path(format: :csv)
      rows = CSV.parse(page.html, headers: true)
      expect( rows.count ).to eq Order.count

      report_countries = rows.map { |r| r["Country"] }
      order_countries  = Order.includes(:country).map { |o| o.country.name }
      expect( report_countries.sort ).to eq order_countries.sort
    end

    it "can see user reports" do
      visit users_reports_path(format: :csv)
      expect{ CSV.parse page.html }.not_to raise_error
    end

    it "can see response time reports" do
      visit pcmo_response_times_reports_path(format: :csv)
      expect{ CSV.parse page.html }.not_to raise_error
    end
  end
end
