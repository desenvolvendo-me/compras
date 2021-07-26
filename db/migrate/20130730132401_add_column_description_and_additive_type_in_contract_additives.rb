class AddColumnDescriptionAndAdditiveTypeInContractAdditives < ActiveRecord::Migration
  def change
    add_column :compras_contract_additives, :description, :text
    add_column :compras_contract_additives, :additive_kind, :string
  end
end
