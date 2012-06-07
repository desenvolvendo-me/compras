class RemoveAccredtions < ActiveRecord::Migration
  def change
    drop_table :accredited_representatives
    drop_table :accreditations
  end
end
