module Medlink
  class Slackbot
    class Test < Slackbot
      attr_reader :requests

      def initialize *args
        @requests = []
        super *args
      end

      def deliver req
        requests.push req
      end

      def messages
        requests.map { |r| text r }
      end

      def last
        text requests.last if requests.any?
      end

      private

      def text request
        URI.unescape request.body.split("&").find { |k| k.start_with? "text" }.split("=").last.gsub("+", " ")
      end
    end
  end
end
