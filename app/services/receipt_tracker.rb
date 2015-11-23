class ReceiptTracker
  def initialize response:
    @response = response
  end

  def acknowledge_receipt by:
    Pundit.authorize by, response, :mark_received?
    response.update! received_at: Time.now, received_by: by, flagged: false
  end

  def flag_for_follow_up by:
    Pundit.authorize by, response, :flag?
    response.update! flagged: true
  end

  private

  attr_reader :response
end
