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
    form = RequestForm.new response.reorders.new
    form.supplies   = response.supplies
    form.entered_by = approver.id
    Pundit.authorize approver, form, :create?
    form.save
    response.update! replacement: form.model, cancelled_at: form.model.created_at
  end

  private

  attr_reader :response, :approver
end
