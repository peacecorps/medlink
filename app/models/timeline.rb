class Timeline
  class Event
    attr_reader :item

    def initialize item
      @item = item
    end

    def type
      item.model_name.singular.to_sym
    end

    def description
      if type == "sms"
        "Message"
      else
        type.to_s.capitalize
      end
    end
  end
  include Enumerable

  attr_reader :user, :duration

  def initialize user, duration: 1.year
    @user, @duration = user, duration
  end

  def each
    (requests + responses + messages).sort_by(&:created_at).reverse.
      each { |e| yield Event.new e }
  end

  def requests
    @_requests ||= fetch(user.requests).includes(orders: [:supply, :response]).to_a
  end
  def responses
    @_responses ||= fetch(user.responses).includes(:orders).to_a
  end
  def messages
    @_messages ||= fetch(user.messages).to_a
  end

  def time_zone
    user.time_zone
  end

  def description_for
  end

  def fetch scope
    scope.where("created_at > ?", duration.ago)
  end
end
