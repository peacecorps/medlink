def random_digits count
  s = ""
  count.times { s += ("1".."9").to_a.sample }
  s
end

desc "Generates random order data"
task :generate => :environment do
  countries = ["United States", "Senegal"].map { |name| Country.where(name: name).first! }
  supplies  = Supply.all
  orders    = 0

  generate_random_order = -> (pcv, date, fulfilled) do
    o = Order.new(
      user: pcv,
      created_at: date,
      supply: supplies.sample,
      location: pcv.location,
      dose: "u",
      quantity: (1..5).to_a.sample
    )
    orders += 1 if o.save

    if fulfilled
      delay = (1..5).to_a.sample
      rdate = [date + delay.days, Date.today].min
      Response.create!(
        order_id: o.id,
        created_at: rdate,
        delivery_method: DeliveryMethod.to_a.sample.name,
        instructions: "Instructions should go here"
      )
    end
  end

  User.all.select { |u| u.email =~ /peacecorps-demo.gov/ }.each &:destroy!

  # Make sure each country has at least 3 PCVs and grab them
  pcvs = []
  countries.each do |country|
    %w{ Alice Bob Charlie }.each do |name|
      email = "#{name}#{country.id}@peacecorps-demo.gov"
      u = User.new(
        first_name: name,
        last_name:  country.name,
        country_id: country.id,
        email:      email,
        location:   "#{name}'s location",
        phone:      random_digits(10),
        pcv_id:     random_digits(5),
        role:       "pcv",
        time_zone:  ActiveSupport::TimeZone.all.sample.name
      )
      u.password = u.password_confirmation = "password"
      u.save!

      pcvs << u
    end
  end

  # Generate random fulfilled orders for the last 2 months
  odds = (1..7).to_a
  1.upto 60 do |n|
    pcvs.each do |pcv|
      if odds.sample == 1
        generate_random_order.call pcv, n.days.ago, true
      end
    end
  end

  # Generate random recent unfulfilled orders
  countries.each do |c|
    locals = pcvs.select { |u| u.country == c }
    2.times do
      n = (3..14).to_a.sample
      pcv = locals.sample
      generate_random_order.call pcv, n.days.ago, false
    end
    4.times do
      n = (1..3).to_a.sample
      pcv = locals.sample
      generate_random_order.call pcv, n.days.ago, false
    end
  end

  puts "Done ... created #{orders} orders"
end

