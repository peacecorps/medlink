class ReportsController < ApplicationController
  def index
    authorize! :report, Order
  end

  def order_history
    authorize! :report, Order
    report = Report::OrderHistory.new(current_user.accessible Order)
    send_data report.to_csv
  end

  def users
    authorize! :report, User
    report = Report::Users.new(User.all)
    send_data report.to_csv
  end

  def pcmo_response_times
    authorize! :report, User
    report = Report::PcmoResponseTimes.new(current_user.accessible Order)
    send_data report.to_csv
  end
end
