class AddSurppressionToContractAdditive < ActiveRecord::Migration
  def change
    add_column :compras_contract_additives, :suppression, :decimal, precision: 10, scale: 2
  end
end