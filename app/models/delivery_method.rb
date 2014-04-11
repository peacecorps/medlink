class DeliveryMethod
  attr_reader :name, :title, :text

  def self.load str
    return str if str.is_a? self
    find { |m| m.name == str }
  end

  def dump
    name
  end

  def initialize *args
    @name, @text, @title = *args
    @title ||= @name.capitalize if @name
    freeze
  end

  def eq other
    name == other.name
  end

  Delivery = new :delivery,
    'Your request is estimated to arrive at your location on [enter date here]'
  Pickup = new :pickup,
    'Your request will be available for pick up at [enter location here] after [enter date]'
  Purchase = new :purchase,
    'We do not have the requested item in stock. Please purchase elsewhere and allow us to
     reimburse you.'.squish, 'Purchase & Reimburse'
  Denial  = new :denial,
    'We are sorry but we are unable to fulfill your request: [enter reason] '

  class << self
    include Enumerable

    def each
      [Delivery, Pickup, Purchase, Denial].each { |m| yield m }
    end
  end
end
