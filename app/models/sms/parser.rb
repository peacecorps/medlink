class SMS
  class Parser
    class Error < StandardError ;; end

    attr_reader :pcv_id, :shortcodes, :instructions

    def initialize text
      @text = text || ""
    end

    def run!
      pref, @instructions = @text.split(/[^\w\s,@]/, 2).map &:strip
      toks = pref.split /[,\s]+/

      if toks.first.start_with? "@"
        @pcv_id = toks.shift[1..-1]
      end

      @shortcodes = toks
    rescue => e
      raise Error, "Failed to parse '#{@text}' - #{e}"
    end
  end
end
