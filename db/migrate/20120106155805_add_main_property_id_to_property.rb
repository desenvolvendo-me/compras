class AddMainPropertyIdToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :main_property_id, :integer
    add_index :properties, :main_property_id
    add_foreign_key :properties, :properties, :column => :main_property_id
  end
end
