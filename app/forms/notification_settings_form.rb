require "reform/form/dry"

class NotificationSettingsForm < Reform::Form
  feature Reform::Form::Dry

  Fields = Notifier.notifications.map(&:key)
  Values = Notifier.strategies.map(&:key)

  Fields.each { |field| property field }

  validation do
    NotificationSettingsForm::Fields.each do |field|
      optional field, included_in?: NotificationSettingsForm::Values
    end
  end

  def strategies
    [Notifier::Strategy::Slack, Notifier::Strategy::Ping, Notifier::Strategy::Log]
  end

  def settings
    model.settings
  end
end
