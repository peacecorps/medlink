require "rails_helper"

RSpec.describe "Dynamic notifier" do
  before(:each) { Notifier.reset!; Medlink.reload(:notifier) }
  after(:all)   { Notifier.reset!; Medlink.reload(:notifier) }

  it "lets admins edit notification settings" do
    Medlink.notify Notification::JobError.new(klass: ApplicationJob, error: "testing")
    expect(Medlink.pingbot.messages.last ).to eq "ApplicationJob: testing"
    expect(Medlink.slackbot.messages.last).not_to eq "ApplicationJob: testing"

    admin = create :admin
    login_as admin

    visit notifier_path
    select "Public Slack channel", from: "[notifier[job_error]]"
    click_on "Save"

    Medlink.notify Notification::JobError.new(klass: ApplicationJob, error: "testing")
    expect(Medlink.slackbot.messages.last).to eq "ApplicationJob: testing"
  end
end
