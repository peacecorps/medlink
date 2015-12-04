class SMS
  Parsed = Struct.new :instructions, :shortcodes

  class Parser
    def initialize text
      @text = text
    end

    def run!
      return unless @text.present?

      pref, instructions = @text.split(/[^\w\s,@]/, 2).map &:strip
      toks = pref.split /[,\s]+/
      return unless toks.any?

      toks.shift if toks.first.start_with? "@"

      Parsed.new instructions, toks.map(&:upcase)
    end
  end
end
