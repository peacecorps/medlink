require "rails_helper"

class NewNotification
  def self.key
    :new_notification
  end

  def text
    "not registered"
  end
end

RSpec.describe Notifier do
  context "building requires a full strategy specification" do
    When(:built) { Notifier.build strategies: {} }

    Then { built == Failure(Notifier::Strategy::Missing) }
  end

  context "notifies on unhandled messages" do
    Given(:notifier) { Notifier.build }

    When(:result) { notifier.call NewNotification.new }

    Then { result == Failure(Notifier::Strategy::Missing) }
  end
end
