namespace :admin do
  task :create => :environment do
    email    = 'admin@pcmedsupplies.org'
    password = 'password123'
    
    puts "Creating admin with email '#{email}' and password '#{password}'"
    u = User.new
    u.email = email
    u.password = u.password_confirmation = password
    u.role = 'admin'
  end
end