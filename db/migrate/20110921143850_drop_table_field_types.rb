class DropTableFieldTypes < ActiveRecord::Migration
  def change
    drop_table :field_types
  end
end
