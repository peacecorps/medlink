class RosterUpload < ActiveRecord::Base
  FetchFailed = Class.new StandardError

  belongs_to :uploader, class_name: "User"
  belongs_to :country

  validates_presence_of :uploader, :country, :body

  def roster
    @_roster ||= Roster.from_csv(body, country: country)
  end

  def fetched?
    body.present?
  end
end
