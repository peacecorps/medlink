require "rails_helper"

class BadJob < ApplicationJob
  def perform
    raise "Whoops"
  end
end

RSpec.describe ApplicationJob do
  When(:result) { BadJob.perform_now }

  Then { result == Failure(RuntimeError, "Whoops") }
  And  { pingbot.last == "BadJob: Whoops"          }
end
