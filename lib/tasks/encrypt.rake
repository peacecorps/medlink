namespace :encrypt do
  task :add => :environment do
    EncryptChallenge.from(ARGV.pop).save!
    exit
  end
end
