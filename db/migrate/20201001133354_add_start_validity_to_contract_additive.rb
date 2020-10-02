class AddStartValidityToContractAdditive < ActiveRecord::Migration
  def change
    add_column :compras_contract_additives, :start_validity, :date
  end
end