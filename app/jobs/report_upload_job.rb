class ReportUploadJob < ApplicationJob
  def perform report_name
    Medlink.report_uploader.call report_name
  end
end
