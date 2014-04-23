class SMS
  # Errors raised in the sms logic may need to be displayed to the
  #   user via text. Messages wrapped in this class are assumed to
  #   be presentable.
  class FriendlyError < StandardError
    def initialize key, subs={}, opts={}
      msg = if opts[:condense]
        SMS::Condenser.new(key, opts[:condense], subs).message
      else
        I18n.t! key, subs
      end
      super msg
    end

    def friendly?; true; end
  end
end
