require "rails_helper"

RSpec.describe ReportUploader do
  Given(:uploader) { ReportUploader.build live: false }

  context "uploading an order report" do
    When(:result) { uploader.call "order history" }

    Then { result.url.include? "reports/test/Order-History"                         }
    And  { result.expires_at < 8.days.from_now                                      }
    And  { Medlink.pingbot.messages.last =~ /^Order History is ready for download/ }
  end

  context "trying a bad report" do
    When(:result) { uploader.call "not a report name" }

    Then { result == Failure(Report::InvalidName) }
  end
end
