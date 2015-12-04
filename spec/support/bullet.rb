RSpec.configure do |config|
  config.around :each, bullet: false do |x|
    Bullet.enable = false
    x.run
    Bullet.enable = true
  end
end
