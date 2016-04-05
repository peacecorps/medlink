class ReportUploadJob < ApplicationJob
  def perform report_name
    ReportUploader.new(report_name).run!
  end
end
