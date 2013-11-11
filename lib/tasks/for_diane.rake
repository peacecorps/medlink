namespace :diane_users do

  desc "Creates users for Diane."
  task :create, [:password] => :environment do |_, args|

    #.................................................................
    email = 'ddeseta@gmail.com'
    names = 'Diane Deseta1'
    password = args[:password] || 'pickapassword'

    pcv_id = rand(1_000_000).to_s
    puts "Creating PCV user '#{email}' with pcv_id '#{pcv_id}' and password '#{password}'"

    user = User.new
    user.email = email
    user.pcv_id = pcv_id
    user.first_name = names.split[0]
    user.last_name = names.split[1]
    user.password = user.password_confirmation = password
    user.country = Country.first || raise("Please generate a country to admin")
    user.role = 'pcv'
    user.location = 'PCV_location'
    user.phone = '404-555-1213'
    user.time_zone = "Alaska"
    user.save!

    #.................................................................
    email = 'deseta@whiteknightllc.com'
    names = 'Diane Desta2'
    password = args[:password] || 'pickapassword'

    pcv_id = rand(1_000_000).to_s
    puts "Creating PCMO user '#{email}' with pcv_id '#{pcv_id}' and password '#{password}'"

    user = User.new
    user.email = email
    user.pcv_id = pcv_id
    user.first_name = names.split[0]
    user.last_name = names.split[1]
    user.password = user.password_confirmation = password
    user.country = Country.first || raise("Please generate a country to admin")
    user.role = 'pcmo'
    user.location = 'PCMO_location'
    user.phone = '404-555-1214'
    user.time_zone = "Alaska"
    user.save!

    #.................................................................
    # OLD PCV
    email = 'diana@RailsUpToDate.com'
    names = 'Diane Desta3'
    password = args[:password] || 'pickapassword'

    pcv_id = rand(1_000_000).to_s
    puts "Creating Admin user '#{email}' with pcv_id '#{pcv_id}' and password '#{password}'"

    user = User.new
    user.email = email
    user.pcv_id = pcv_id
    user.first_name = names.split[0]
    user.last_name = names.split[1]
    user.password = user.password_confirmation = password
    user.country = Country.first || raise("Please generate a country to admin")
    user.role = 'pcv'
    user.location = 'Admin_location'
    user.phone = '404-555-1215'
    user.time_zone = "Alaska"
    user.save!
  end
end
