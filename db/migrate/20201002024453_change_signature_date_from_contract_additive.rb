class ChangeSignatureDateFromContractAdditive < ActiveRecord::Migration
  def change
    change_column :compras_contract_additives, :signature_date, :date, null: true
  end
end
