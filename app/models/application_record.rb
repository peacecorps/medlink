class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.newest n=nil
    order(created_at: :desc).first n
  end

  def self.random n=1
    found = all.to_a.sample n
    raise unless found.count == n
    n == 1 ? found.first : found
  end if Rails.env.test? # This isn't performany and shouldn't be relied on
end
