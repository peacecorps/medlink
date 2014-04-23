class SMS
  # Handles the common pattern of internationalizing, pluralizing and
  #   compressing "<supply name> and <count> other supplies" to fit
  #   into an SMS-sized response
  #
  # Note: `key` needs to be singular so that the "+ 1 other <item>"
  #   message can be generated correctly
  class Condenser
    include ActionView::Helpers::TextHelper

    def initialize template, key, subs
      @template, @key, @subs = template, key, subs.clone
      @key_plural = @key.to_s.pluralize.to_sym
      @values = @subs.delete @key_plural
      @target = SMS::MAX_LENGTH
    end

    def message
      loop do
        return full    if full.length    <= @target
        return partial if partial.length <= @target
        @target += SMS::MAX_LENGTH
      end
    end

    private

    def t slot
      I18n.t! @template, @subs.merge(@key_plural => slot)
    end

    def full
      @_full ||= t @values.to_sentence
    end

    def partial
      # TODO: this is en-specific
      @_partial ||= begin
        slot = "#{@values.first}"
        if @values.length > 1
          others = pluralize (@values.length - 1), "other #{@key}"
          slot  += " and #{others}"
        end
        t slot
      end
    end
  end
end
