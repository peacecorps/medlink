class DeliveryMethod
  Denial = :denial

  attr_accessor :name, :title, :text

  def initialize name, text, title=nil
    @name, @text, @title = name, text, title
    @title ||= @name.capitalize
    freeze
  end

  def eq other
    name == other.name
  end

  class << self
    include Enumerable

    def each
      # R3
      yield new :delivery, 'Your request is estimated to arrive at your ' +
        'location on [enter date here]'
      # R1
      yield new :pickup, 'Your request will be available for pick up at ' +
        '[enter location here] after [enter date]'
      # R2
      yield new :purchase, 'We do not have the requested item in stock. ' +
        'Please purchase elsewhere and allow us to reimburse you.',
        'Purchase & Reimburse'
      # R4
      yield new :special, '[enter special istructions] ', 'Special Instructions'
      # R5
      yield new Denial, 'We sorry but we are unable to fufill your request. [enter reason] '
    end
  end
end

