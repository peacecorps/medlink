class Reform::Form
  # FIXME: this seems necessary (for bootstrap_form_for?). Figure out why (and submit PR?).
  def self.validators_on name
    validator._validators[name]
  end
end
