class MailerJob < BaseJob
  @queue = :email

  def self.perform method, *args
    UserMailer.send(method, *args).try :deliver
  end
end