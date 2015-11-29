class RequestPresenter < Draper::Decorator
  delegate_all

  def reordered?
    reorder_of_id.present?
  end
end
