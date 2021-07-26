class AddAdditiveKindValueToContractAdditive < ActiveRecord::Migration
  def change
    add_column :compras_contract_additives, :additive_kind_value, :decimal, precision: 10, scale: 2
  end
end
