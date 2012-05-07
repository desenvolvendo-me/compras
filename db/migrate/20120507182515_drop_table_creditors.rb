class DropTableCreditors < ActiveRecord::Migration
  def change
    drop_table :creditors
  end
end
