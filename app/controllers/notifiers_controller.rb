class NotifiersController < ApplicationController
  def show
    @notifier = Medlink.notifier
    authorize @notifier
  end

  def update
    authorize Medlink.notifier
    Notifier.save_strategies! params[:notifier].to_unsafe_h
    Medlink.reload(:notifier)
    redirect_back fallback_location: notifier_path, notice: "Preferences saved"
  rescue Notifier::Strategy::Missing => e
    # :nocov:
    redirect_back fallback_location: notifier_path, danger: e.message
    # :nocov:
  end
end
