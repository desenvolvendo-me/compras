class AddEndValidityToContractAdditive < ActiveRecord::Migration
  def change
    add_column :compras_contract_additives, :end_validity, :date
  end
end