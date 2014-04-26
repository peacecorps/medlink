class DeliveryMethod
  attr_reader :name, :title, :text

  def self.load str
    return str if str.is_a? self
    return unless str
    find { |m| m.name.to_s == str.to_s }
  end

  def self.dump method
    method.name if method
  end

  def initialize *args
    @name, @text, @title = *args
    @title ||= @name.capitalize if @name
    freeze
  end

  def == other
    name == other.name
  end

  module Choices
    Delivery = DeliveryMethod.new :delivery,
      'Your request is estimated to arrive at your location on [enter date here]'
    Pickup = DeliveryMethod.new :pickup,
      'Your request will be available for pick up at [enter location here] after [enter date]'
    Purchase = DeliveryMethod.new :purchase,
      'We do not have the requested item in stock. Please purchase elsewhere and allow us to
       reimburse you.'.squish, 'Reimburse'
    Denial = DeliveryMethod.new :denial,
      'We are sorry but we are unable to fulfill your request: [enter reason]'
  end
  include Choices

  class << self
    include Enumerable

    def each
      Choices.constants.each { |name| yield const_get(name) }
    end
  end
end
