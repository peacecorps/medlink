class NotifiersController < ApplicationController
  def show
    @notifier = NotificationSettingsForm.new Medlink.notifier.preferences
    authorize @notifier
  end

  def update
    notifier = NotificationSettingsForm.new Medlink.notifier.preferences
    authorize notifier
    if notifier.validate params[:notifier]
      notifier.save
      Medlink.reload :notifier
      redirect_back fallback_location: notifier_path, notice: "Preferences saved"
    else
      # :nocov:
      redirect_back fallback_location: notifier_path, danger: notifier.errors.full_messages.to_sentence
      # :nocov:
    end
  end
end
