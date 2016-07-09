require "ice_nine/core_ext/object"

class Reform::Form
  # FIXME: this seems necessary (for bootstrap_form_for?). Figure out why (and submit PR?).
  def self.validators_on name
    validator._validators[name]
  end
end

module Rails
  module ConsoleMethods
    unless Rails.env.production?
      def me
        User.find_by email: `git config user.email`.strip
      end
    end
  end
end
