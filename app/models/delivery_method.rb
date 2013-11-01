class DeliveryMethod
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
        'location on this date [enter date here].'
      # R1
      yield new :pickup, 'Please pick up your request at this ' +
        '[enter location here] by this [enter date]'
      # R2
      yield new :purchase, 'We do not have the requested item in stock. ' +
        'Please purchase elsewhere and allow us to reimburse you.',
        'Purchase & Reimburse'
      # R4
      yield new :special, 'Please contact me at this [phone number] ' +
        'concerning your request.', 'Special Instructions'
    end
  end
end

