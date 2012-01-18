class RemoveStreetIdFromUrbanServices < ActiveRecord::Migration
  def up
    remove_column :urban_services, :street_id
  end

  def down
    add_column :urban_services, :street_id, :integer
    add_index :urban_services, :street_id
    add_foreign_key :urban_services, :streets
  end
end
