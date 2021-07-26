class RemoveCreditorIdFromContracts < ActiveRecord::Migration
  def change
    execute <<-SQL
      INSERT INTO compras_contracts_creditors
      SELECT id, creditor_id FROM compras_contracts
    SQL

    remove_column :compras_contracts, :creditor_id
  end
end
