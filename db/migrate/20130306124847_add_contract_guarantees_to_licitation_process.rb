class AddContractGuaranteesToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :contract_guarantees, :string
    remove_column :compras_contracts, :contract_guarantees
  end
end
