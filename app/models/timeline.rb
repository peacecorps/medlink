class Timeline
  include Enumerable

  attr_reader :user, :duration

  def initialize user, duration: 1.year, requests: nil, responses: nil, messages: nil
    @user, @duration = user, duration
  end

  def each
    (requests + responses + messages).
      sort_by(&:created_at).
      reverse_each { |e| yield presenter_for e }
  end

  def requests
    @requests ||= fetch(user.requests).includes(orders: [:supply, :response]).to_a
  end
  def responses
    @responses ||= fetch(user.responses).includes(:orders).to_a
  end
  def messages
    @messages ||= fetch(user.messages).to_a
  end

  def time_zone
    user.time_zone
  end

  def country_id
    @user.country_id
  end

  private

  def fetch scope
    scope.where("created_at > ?", duration.ago)
  end

  def presenter_for item
    klass = {
      SMS      => TimelineMessagePresenter,
      Request  => TimelineRequestPresenter,
      Response => TimelineResponsePresenter
    }.fetch item.class
    klass.new item
  end
end
