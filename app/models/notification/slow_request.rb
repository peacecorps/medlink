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
      "#{user.name} (#{user.email})"
    end
  end
end
