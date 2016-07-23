require "rails_helper"

RSpec.describe Notification::AnnouncementScheduled do
  Given(:announcement) { build :announcement, id: rand }

  When(:note) { described_class.new announcement: announcement }

  Then { note.text.include? announcement.id.to_s       }
  And  { note.text.include? announcement.country.name  }
  And  { note.text.include? announcement.message       }
  And  { note.slack.include? announcement.id.to_s      }
  And  { note.slack.include? announcement.country.name }
  And  { note.slack.include? announcement.message      }
end
