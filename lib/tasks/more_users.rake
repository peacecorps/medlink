namespace :more_users do

  desc "Creates more users"
  task :create, [:password] => :environment do |_, args|

    #.................................................................
    email = rand(1000).to_s + 'pcv@hotmail.com'
    names = 'Mr. PCV'
    password = args[:password] || 'password'
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
    user.location = 'PCVille'
    user.phone = '404-555-1213'
    user.time_zone = "Alaska"
    user.save!

    #.................................................................
    email = rand(1000).to_s + 'pcmo@hotmail.com'
    names = 'Mr. PCMO'
    password = args[:password] || 'password'
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
    user.location = 'PCMOville'
    user.phone = '404-555-1214'
    user.time_zone = "Alaska"
    user.save!

    #.................................................................
    # OLD PCV
    email = rand(1000).to_s + 'old_pcv@hotmail.com'
    names = 'Mr. OLD_PCV'
    password = args[:password] || 'password'
    pcv_id = rand(1_000_000).to_s

    puts "Creating OLD PCV user '#{email}' with pcv_id '#{pcv_id}' and password '#{password}'"

    user = User.new
    user.email = email
    user.pcv_id = pcv_id
    user.first_name = names.split[0]
    user.last_name = names.split[1]
    user.password = user.password_confirmation = password
    user.country = Country.first || raise("Please generate a country to admin")
    user.role = 'pcv'
    user.location = 'OldPCVille'
    user.phone = '404-555-1215'
    user.time_zone = "Alaska"
    user.save!
    user.created_at = user.created_at - 4.days.ago

    #.................................................................
    email = rand(1000).to_s + 'old_pcmo@hotmail.com'
    names = 'Mr. OLD_PCMO'
    password = args[:password] || 'password'
    pcv_id = rand(1_000_000).to_s

    puts "Creating OLD PCMO user '#{email}' with pcv_id '#{pcv_id}' and password '#{password}'"

    user = User.new
    user.email = email
    user.pcv_id = pcv_id
    user.first_name = names.split[0]
    user.last_name = names.split[1]
    user.password = user.password_confirmation = password
    user.country = Country.first || raise("Please generate a country to admin")
    user.role = 'pcmo'
    user.location = 'OldPCMOville'
    user.phone = '404-555-1215'
    user.time_zone = "Alaska"
    user.save!
    user.created_at = user.created_at - 4.days.ago
  end
end
