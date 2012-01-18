class RemoveDistrictFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :district_id
  end

  def down
    add_column :properties, :district_id, :integer
    add_foreign_key :properties, :districts
    add_index :properties, :district_id
  end
end
