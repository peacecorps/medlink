class Response < ActiveRecord::Base
end

class UpdateArchives < ActiveRecord::Migration
  def up
    Response.find_each do |response|
      if t = response.archived_at
        response.update! received_at: t
      end
    end
  end
end
