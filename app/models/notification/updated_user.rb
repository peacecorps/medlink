module Notification
  class UpdatedUser < Notification::Base
    def initialize user:, changes:
      @user, @changes = user, changes
    end

    def text
      "#{@user.email} (##{@user.id}) has been updated - #{@changes}"
    end
  end
end
