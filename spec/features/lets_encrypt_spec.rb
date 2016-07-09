require "rails_helper"

RSpec.describe "Let's Encrypt" do
  it "can register a new key" do
    EncryptChallenge.from("foo.bar").save!
    visit "/.well-known/acme-challenge/foo"
    expect(page.body).to eq "foo.bar"
  end

  it "requires a matching key" do
    EncryptChallenge.from("foo.bar").save!
    expect do
      visit "/.well-known/acme-challenge/floop"
    end.to raise_error ActiveRecord::RecordNotFound
  end

  it "only finds recent keys" do
    key = EncryptChallenge.from "foo.bar"
    key.update! created_at: 2.days.ago

    expect do
      visit "/.well-known/acme-challenge/foo"
    end.to raise_error ActiveRecord::RecordNotFound
  end
end
