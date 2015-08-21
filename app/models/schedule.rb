class Schedule
  include Virtus.model

  attribute :days, Array[Integer]
  attribute :hour, Integer
end
