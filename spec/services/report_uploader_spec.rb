require "rails_helper"

RSpec.describe ReportUploader do
  Given(:notifications) { [] }
  Given(:notify) { ->(key, msg) { notifications.push msg } }
  Given(:upload) { ->(report)   { ReportUploader::Upload.new "s3url", 1.day.from_now } }
  Given(:uploader) { ReportUploader.build uploader: upload, notifier: notify }

  context "uploading an order report" do
    When(:result) { uploader.call "order history" }

    Then { result.url == "s3url"                                         }
    And  { result.expires_at < 2.days.from_now                           }
    And  { notifications.first =~ /^Order History is ready for download/ }
  end

  context "trying a bad report" do
    When(:result) { uploader.call "not a report name" }

    Then { result == Failure(Report::InvalidName) }
  end
end
