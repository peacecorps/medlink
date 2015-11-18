class ActiveRecord::Base
  def self.newest
    order(created_at: :desc).first
  end
end
