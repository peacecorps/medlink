namespace :admin do

  desc "Creates an admin user from your git config (password optional)"
  task :create, [:password] => :environment do |_, args|

    raise 'Please install and configure git' unless system 'which git >/dev/null'

    email = `git config user.email`.strip
    names = `git config user.name`.strip.split ' '
    if email.empty? || names.empty?
      raise 'Please configure your git user name and email. See the README for more information'
    end

    password = args[:password] || 'password'
    pcv_id   = rand(1_000_000).to_s

    puts "Creating user '#{email}' with pcv_id '#{pcv_id}' and password '#{password}'"

    country = Country.all.sample
    user = User.create! \
      email:        email,
      pcv_id:       pcv_id,
      first_name:   names.first,
      last_name:    names.last,
      password:     password,
      country:      country,
      role:         :admin,
      location:     "---",
      time_zone:    country.time_zone,
      confirmed_at: 1.week.ago
    user.phones.create! number: '+1 404-555-1212'
  end

end
