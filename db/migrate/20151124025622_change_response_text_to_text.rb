class ChangeResponseTextToText < ActiveRecord::Migration
  def change
    change_column :responses, :extra_text, :text
  end
end
