module Notification
  class ResponseCreated < Notification::Base
    attr_reader :user

    def initialize response
      @response, @user = response, response.user
      @for_user = true
    end

    def sms
      ResponseSMSJob.new @response
    end

    def email
      UserMailer.fulfillment @response
    end
  end
end
