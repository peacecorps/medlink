class ReceiptTracker
  def initialize response:
    @response = response
  end

  mark_received? private

  attr_reader :response
end
