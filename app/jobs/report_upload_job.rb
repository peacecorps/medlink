class ReportUploadJob < ApplicationJob
  def perform report_name
    Rails.configuration.container.resolve(:report_uploader).call report_name
  end
end
