class ReportsController < ApplicationController
  def index
    authorize :order, :report?
  end

  def order_history
    authorize :order, :report?
    report = Report::OrderHistory.new policy_scope Order
    send_data report.to_csv
  end

  def users
    authorize :user, :report?
    report = Report::Users.new policy_scope User.all
    send_data report.to_csv
  end

  def pcmo_response_times
    authorize :user, :report?
    report = Report::PcmoResponseTimes.new policy_scope Order
    send_data report.to_csv
  end
end
