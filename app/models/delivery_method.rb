class DeliveryMethod
  attr_reader :name, :title, :text

  def initialize name, text, title=nil
    @name, @text, @title = name, text, title
    @title ||= @name.capitalize
    freeze
  end

  def eq other
    name == other.name
  end

  def to_s
    name.to_s
  end

  Delivery = new :delivery,
    'Your request is estimated to arrive at your location on [enter date here]'
  Pickup = new :pickup,
    'Your request will be available for pick up at [enter location here] after [enter date]'
  Purchase = new :purchase,
    'We do not have the requested item in stock. Please purchase elsewhere and allow us to
     reimburse you.'.squish, 'Purchase & Reimburse'
  Special = new :special, '[enter special instructions] ', 'Special Instructions'
  Denial  = new :denial,
    'We are sorry but we are unable to fulfill your request: [enter reason] '

  class << self
    include Enumerable

    def each
      # R3, R1, R2, R4, R5, resp.
      [Delivery, Pickup, Purchase, Special, Denial].each { |m| yield m }
    end
  end
end

