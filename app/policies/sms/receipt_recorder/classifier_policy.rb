class SMS::ReceiptRecorder::ClassifierPolicy < ApplicationPolicy
  def update?
    admin?
  end
end
