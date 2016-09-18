module Notification
  class SlowRequest < Notification::Base
    attr_reader :action, :path, :user, :duration

    def initialize action:, path:, user:, duration:
      @action, @path, @user, @duration = action, path, user, duration
    end

    def text
      "`#{path} => #{action}` took #{duration.round 2} for #{describe_user}"
    end

    private

    def describe_user
      if user
        "#{user.name} (#{user.id} / #{user.role} in #{user.country.try :name})"
      else
        "unknown user"
      end
    end
  end
end
