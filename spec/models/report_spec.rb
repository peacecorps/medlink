require "rails_helper"

class BackwardsDecorator
  def initialize word
    @word = word
  end
  def to_s
    @word
  end
  def backwards
    @word.reverse
  end
end

class ReverseReport < Report::Base
  decorator BackwardsDecorator

  def initialize words
    self.rows = words
  end

  def format word
    { forwards: word, backwards: word.backwards }
  end
end


RSpec.describe Report do
  Given(:report) { ReverseReport.new %w(correct horse battery staple) }
  When(:result)  { CSV.parse report.to_csv, headers: true }

  Then { result.count == 4                                                             }
  And  { result.first.to_hash == { "forwards" => "correct", "backwards" => "tcerroc" } }
end
