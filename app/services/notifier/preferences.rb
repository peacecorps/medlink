class Notifier
  class Preferences
    class Base
      Notifier.notifications.each do |n|
        define_method n.key do
          @settings[n]
        end

        define_method "#{n.key}=" do |keys|
          @settings[n] = Array(keys).map { |key| Notifier::Strategy.fetch key }
        end
      end

      attr_reader :settings

      def initialize user
        @user     = user
        @settings = load
      end

      def for klass
        @settings[klass]
      end

      def save
        Medlink.redis { |r| r.set key, to_json }
      end

      def reset!
        Medlink.redis { |r| r.del key }
        @settings = load
        save
      end

      def inspect
        # :nocov:
        "<#{self.class.name}(#@user)>"
        # :nocov:
      end

      private

      attr_reader :user

      def to_json
        @settings.map { |k,vs| [k.key, vs.map(&:key) ]}.to_h.to_json
      end

      def from_json saved
        saved ||= "{}"
        hydrate defaults.merge JSON.parse(saved).transform_keys(&:to_sym)
      end

      def load
        from_json(Medlink.redis { |r| r.get key })
      end

      def hydrate h
        h.each_with_object({}) do |(key,strats),res|
          res[ Notifier.fetch(key) ] = strats.map { |s| Notifier::Strategy.fetch(s.to_sym) }
        end
      end
    end

    class System < Base
      def initialize
        super :system
      end

      def key
        "notifier.strategies"
      end

      def defaults
        {
          sending_country_sms:           [:slack],
          user_activated:                [:slack],
          invalid_response_receipt:      [:slack],
          reprocessing_response_receipt: [:slack],
          sms_help_needed:               [:slack],
          invalid_roster_upload_row:     [:ping],
          announcement_scheduled:        [:ping],
          job_error:                     [:ping],
          flag_for_followup:             [:ping],
          slow_request:                  [:ping],
          spam_warning:                  [:ping],
          unrecognized_sms:              [:ping],
          updated_user:                  [:ping],
          new_report_ready:              [:ping],
          sending_response:              [:log],
          prompt_for_acknowledgement:    [:log],
          delivery_failure:              [:log]
        }
      end
    end

    class User < Base
      def key
        "notifier.strategies.user:#{user.id}"
      end

      def defaults
        {
          response_created: [:email, :sms]
        }
      end
    end
  end
end
