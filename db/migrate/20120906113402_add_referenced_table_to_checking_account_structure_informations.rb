class AddReferencedTableToCheckingAccountStructureInformations < ActiveRecord::Migration
  def change
    add_column :compras_checking_account_structure_informations, :referenced_table, :string
  end
end
