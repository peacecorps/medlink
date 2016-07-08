class EncryptChallenge < ApplicationRecord
  validates_presence_of :pre, :post
  validates_uniqueness_of :pre

  scope :recent, -> { where "created_at > ?", 1.day.ago }

  def self.from key
    pre, post = key.split "."
    new pre: pre, post: post
  end

  def full
    "#{pre}.#{post}"
  end
end
