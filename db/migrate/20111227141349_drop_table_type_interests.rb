class DropTableTypeInterests < ActiveRecord::Migration
  def change
    drop_table :type_interests
  end
end
