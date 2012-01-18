class RemoveApartmentBlockFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :apartment_block
  end

  def down
    add_column :properties, :apartment_block, :string
  end
end
