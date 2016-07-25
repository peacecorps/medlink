require "rails_helper"

class NewNotification
  def self.key
    :new_notification
  end

  def for_user? ; end
  def text      ; end
end

RSpec.describe Notifier do
  context "notifies on unhandled messages" do
    Given(:notifier) { Notifier.build }

    When(:result) { notifier.call NewNotification.new }

    Then { result == Failure(Notifier::Strategy::Missing) }
  end
end
