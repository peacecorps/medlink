namespace :admin do
  
  desc "Creates an admin user from your git config (password optional)"
  task :create, [:password] => :environment do |_, args|

    raise 'Please install and configure git' unless system 'which git >/dev/null'

    email = `git config user.email`.strip
    names = `git config user.name`.strip.split ' '
    password = args[:password] || 'password'
    pcv_id = rand(1_000_000).to_s

    puts "Creating user '#{email}' with pcv_id '#{pcv_id}' and password '#{password}'"

    user = User.new
    user.email = email
    user.pcv_id = pcv_id
    user.first_name = names.first
    user.last_name = names.last
    user.password = user.password_confirmation = password
    user.country = Country.first || raise("Please generate a country to admin")
    user.city = '-'
    user.role = 'admin'
    user.location = 'Buckhead'
    user.phone = '404-555-1212'
    user.save!
  end

end
