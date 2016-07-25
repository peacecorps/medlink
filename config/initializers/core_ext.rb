require "ice_nine/core_ext/object"

module Rails
  module ConsoleMethods
    unless Rails.env.production?
      def me
        User.find_by email: `git config user.email`.strip
      end
    end
  end
end
