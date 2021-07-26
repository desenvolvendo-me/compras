class AddNestedSetRequiredFieldsToContracts < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :lft, :integer
    add_column :compras_contracts, :rgt, :integer
  end
end
