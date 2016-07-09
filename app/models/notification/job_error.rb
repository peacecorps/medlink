module Notification
  class JobError < Notification::Base
    def initialize klass:, error:
      @klass, @error = klass, error
    end

    def text
      "#{@klass}: #{@error}"
    end
  end
end
