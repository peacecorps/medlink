require "rails_helper"

RSpec.describe Notification::InvalidRosterUploadRow do
  Given(:row) { Roster::Row.new email: "annie@example.com" }

  When(:result) { described_class.new row: row, action: "create", error: RuntimeError.new("blerg") }

  Then { result.text.include? "create"            }
  And  { result.text.include? "blerg"             }
  And  { result.text.include? "annie@example.com" }
end
