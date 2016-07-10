class SMS::ReceiptRecorder
  class Classifier
    AFFIRMATIONS = "receipt-recorder:affirmations"
    NEGATIONS    = "receipt-recorder:negations"

    def self.reset!
      Medlink.redis do |r|
        r.pipelined do
          r.del AFFIRMATIONS
          r.del NEGATIONS
        end
      end
    end

    def initialize
      @affirmations = redis_cached AFFIRMATIONS, default: [
        "yes", "y", "got it","got it!", "ok", "okay", "yes!",
        "yes.", "si", "si!", "-yes", "I recieved my medicine", "yes. Thanks!",
        "yes. Thank you.", "yes. Thank you!", "yes and thank you",
        "yes and thank you!", "yea", "yeah", "hi, yes!", "hi, yes!", "yes:)",
        "yes :)", "Yes, thanks for checking!", "Yes I did!", "Got it :) Thanks!",
        "yes i did. thanks", "Yes (received order)", "yep", "yup"
      ]
      @negations = redis_cached NEGATIONS, default: [
        "no", "no!", "n", "nope", "flag", "not yet", "not yet."
      ]
    end

    attr_reader :affirmations, :negations

    def affirmative? msg
      msg = standardize msg
      msg =~ /^yes/ || affirmations.include?(msg)
    end

    def negative? msg
      negations.include? standardize msg
    end

    def affirmative! msgs
      redis_set AFFIRMATIONS, msgs
    end

    def negative! msgs
      redis_set NEGATIONS, msgs
    end

    private

    def standardize msg
      msg.strip.downcase.gsub(/[^a-z ]+/, '').squish
    end

    def redis_cached key, default:
      found = Set.new Medlink.redis { |r| r.smembers key }
      if found.any?
        found
      else
        redis_set key, default
      end
    end

    def redis_set key, arg
      words = Array(arg).map { |w| standardize w }
      Medlink.redis do |r|
        r.pipelined do
          r.del  key
          r.sadd key, words
        end
      end
      Set.new words
    end
  end
end
