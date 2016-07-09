module Notification
  class SendingCountrySMS < Notification::Base
    def initialize country:, message:, count:
      @country, @message, @count = country, message, count
    end

    def text
      "Sending #{@message} to #{@count} users in #{@country.name}"
    end
  end
end
