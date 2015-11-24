class ReceiptTracker
  def initialize response:, approver:
    @response, @approver = response, approver
  end

  def acknowledge_receipt
    Pundit.authorize approver, response, :mark_received?
    response.update! received_at: Time.now, received_by: approver, flagged: false
  end

  def flag_for_follow_up
    Pundit.authorize approver, response, :flag?
    response.update! flagged: true
  end

  def reorder
    request = response.reorders.new supplies: response.supplies
    Pundit.authorize! approver, request, :create?
    request.save!
    # FIXME: I shouldn't have had to remember to put this here v
    OrderMonitor.new.new_request request
    response.update! replacement: rc.request, cancelled_at: rc.request.created_at
  end

  private

  attr_reader :response, :approver
end
