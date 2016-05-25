require "rails_helper"

RSpec.describe SlowRequestNotifier do
  Given(:notifications) { [] }
  Given(:monitor) {
    SlowRequestNotifier.build \
      timeout: 0.01,
      notifier: ->(n) { notifications.push n }
  }

  context "quick request" do
    When(:result) do
      monitor.call(action: "action", path: "path", user: nil) { 1 + 1 }
    end

    Then { result == 2          }
    And  { notifications.empty? }
  end

  context "slow request with unknown user" do
    When(:result) do
      monitor.call(action: "action", path: "path", user: nil) do
        sleep 0.02
        1 + 1
      end
    end

    Then { result == 2 }
    And  { notifications == ["`path => action` took 0.02 for unknown user"] }
  end

  context "slow request with known user" do
    Given(:country) { instance_double Country, name: "Country" }
    Given(:user)    { instance_double User, id: 1234, name: "Name", role: "PCMO", country: country }

    When(:result) do
      monitor.call(action: "action", path: "path", user: user) do
        sleep 0.02
        2 + 2
      end
    end

    Then { result == 4 }
    And  { notifications == ["`path => action` took 0.02 for Name (1234 / PCMO in Country)"] }
  end
end
