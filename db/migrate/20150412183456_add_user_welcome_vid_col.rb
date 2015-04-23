class AddUserWelcomeVidCol < ActiveRecord::Migration
  def change
    add_column :users, :welcome_video_shown_at, :datetime
  end
end
