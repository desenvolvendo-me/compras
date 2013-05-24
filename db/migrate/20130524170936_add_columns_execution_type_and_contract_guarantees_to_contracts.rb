class AddColumnsExecutionTypeAndContractGuaranteesToContracts < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :execution_type, :string
    add_column :compras_contracts, :contract_guarantees, :string

    remove_column :compras_contracts, :direct_purchase_id
  end
end
