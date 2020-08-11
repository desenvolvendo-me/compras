class RenameTypeToContract < ActiveRecord::Migration
  def change
    rename_column :compras_contracts, :type, :type_contract
  end
end
