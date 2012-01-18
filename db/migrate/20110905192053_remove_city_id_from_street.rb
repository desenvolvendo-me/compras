class RemoveCityIdFromStreet < ActiveRecord::Migration
  def up
    remove_column :streets, :city_id
  end

  def down
    add_column :streets, :city_id, :integer
    add_index :streets, :city_id
    add_foreign_key :streets, :cities
  end
end
