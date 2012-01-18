class RemoveApartmentFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :apartment
  end

  def down
    add_column :properties, :apartment, :string
  end
end
