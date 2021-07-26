class AddTerminationValueToComprasContractTerminations < ActiveRecord::Migration
  def change
    add_column :compras_contract_terminations, :termination_value, :decimal,
      precision: 10, scale: 2, null: true
  end
end
