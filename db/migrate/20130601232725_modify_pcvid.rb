class ModifyPcvid < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :pcv_id, :string
    end
  end

  def down
    raise "Not Implemented"
  end
end
