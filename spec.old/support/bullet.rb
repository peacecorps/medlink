RSpec.configure do |config|
  config.before :each, no_bullet: true do
    Bullet.enable = false
  end
  config.after :each, no_bullet: true do
    Bullet.enable = true
  end
end
