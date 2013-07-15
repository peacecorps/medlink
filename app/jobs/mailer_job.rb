class MailerJob < BaseJob
  include SuckerPunch::Job

  def perform method, *args
    # Need to be careful not to exhaust the connection pool
    ActiveRecord::Base.connection_pool.with_connection do
      UserMailer.send(method, *args).try :deliver
    end
  end
end
