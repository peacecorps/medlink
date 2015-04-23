ActionMailer::Base.smtp_settings = {
  :address   => "smtp.mandrillapp.com",
  :port      => 587,
  :user_name => "app15863835@heroku.com",
  :password  => ENV["MANDRILL_APIKEY"]
}
