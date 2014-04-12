require 'spec_helper'

describe SMS::Parser do
  def parse text
    SMS::Parser.new(text).tap &:run!
  end

  it "can parse space separated" do
    p = parse "a b c d"
    expect( p.shortcodes ).to eq %w(a b c d)
  end

  it "can parse with instructions" do
    p = parse "a b c d - pls"
    expect( p.shortcodes ).to eq %w(a b c d)
    expect( p.instructions ).to eq "pls"
  end

  it "can parse with other separators" do
    p = parse "a,b, c ,  d    ;    why?"
    expect( p.shortcodes ).to eq %w(a b c d)
    expect( p.instructions ).to eq "why?"
  end

  it "can parse a pcv id" do
    p = parse "@123 a b c"
    expect( p.pcv_id ).to eq "123"
    expect( p.shortcodes ).to eq %w(a b c)
  end

  it "isn't thrown by instructions containing separators" do
    p = parse "@123 a,b,c - Lost my phone, sorry\n:/"
    expect( p.pcv_id ).to eq "123"
    expect( p.shortcodes ).to eq %w(a b c)
    expect( p.instructions ).to eq "Lost my phone, sorry\n:/"
  end
end
