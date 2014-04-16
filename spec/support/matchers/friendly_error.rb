RSpec::Matchers.define :raise_friendly_error do |msg|
  match do |actual|
    expect( actual ).to raise_error { |e|
      expect( e ).to be_friendly
      expect( e.message ).to match_regex msg
    }
  end
end
