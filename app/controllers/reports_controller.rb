class ReportsController < ApplicationController
  def index
    @reports = Report.all
    authorize :order, :report?
  end

  def download
    klass  = Report.named params[:report_name]
    report = klass.new policy_scope klass.model
    authorize klass
    send_data report.to_csv, type: "application/csv", filename: report.filename
  end
end
