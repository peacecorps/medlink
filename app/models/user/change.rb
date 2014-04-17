class User
  class Change
    def initialize old, user
      @user    = user
      @changes = old.keys.select { |k| old[k] != @user.attributes[k] }
      @changes.delete "updated_at"
    end

    def changed?
      !@changes.empty?
    end

    def summary
      @changes.map { |k| summarize k }.join "; "
    end

    private

    def summarize key
      if key == "country_id"
        "country=[#{@user.country.name}]"
      else
        "#{key}=[#{@user[key]}]"
      end
    end
  end
end
