require "rails_helper"

RSpec.describe ReportUploadJob do
  When(:result) { described_class.new.perform "floop" }

  Then { result == Failure(Report::InvalidName, /floop/) }
end
