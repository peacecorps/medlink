require "rails_helper"

RSpec.describe Notification::FlagForFollowup do
  Given(:response) { build :response, id: rand }
  Given(:count)    { rand 1 .. 10 }

  When(:note) { described_class.new response: response, count: count }

  Then { note.text.include?  response.id.to_s   }
  And  { note.text.include?  count.to_s         }
  And  { note.slack.include? response.id.to_s   }
  And  { note.slack.include? count.to_s         }
end
