require "rails_helper"

RSpec.describe RosterUploadFetchJob do
  context "downloading a file", :vcr do
    Given(:roster) { FactoryGirl.build :roster_upload, uri: "https://s3.amazonaws.com/medlink-staging.jcd/test/users.csv" }

    When { RosterUploadFetchJob.new.perform roster }

    Then { roster.body.start_with? "email," }
    And  { roster.fetched?                  }
  end

  context "failing to download a file", :vcr do
    Given(:roster) { FactoryGirl.build :roster_upload, uri: "https://s3.amazonaws.com/medlink-staging.jcd/dev/null" }

    When(:result) { RosterUploadFetchJob.new.perform roster }

    Then { result == Failure(RosterUpload::FetchFailed, /#{roster.id}/) }
    And  { !roster.body.present?                                        }
    And  { !roster.fetched?                                             }
    And  { slackbot.messages.last =~ /upload/                           }
  end
end
