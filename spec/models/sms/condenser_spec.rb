require "spec_helper"

describe SMS::Condenser do
  it "can handle waaaay too long messages" do
    I18n.backend.store_translations :en,
      long: "#{'x' * 70} %{names} #{'x' * 70}"

    msg = SMS::Condenser.new(:long, :name,
      names: %w(a b c d e).map { |c| c * 50 }
    ).message

    expect( msg.length ).to be > 160
    expect( msg.length ).to be < 320
    expect( msg ).to match /a and 4 other names/i
  end
end
