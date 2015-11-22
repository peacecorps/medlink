class ActiveRecord::Base
  def self.newest
    order(created_at: :desc).first
  end

  if Rails.env.test?
    # Convenience method for grabbing seeded data; this isn't performant and shouldn't be used outside test
    def self.random n=1
      found = order("random()").first n
      raise unless found.count == n
      n == 1 ? found.first : found
    end
  end
end

class Reform::Form
  # FIXME: this seems necessary (for bootstrap_form_for?). Figure out why (and submit PR?).
  def self.validators_on name
    validator._validators[name]
  end
end
