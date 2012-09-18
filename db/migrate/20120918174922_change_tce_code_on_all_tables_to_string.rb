class ChangeTceCodeOnAllTablesToString < ActiveRecord::Migration
  def change
    change_column :compras_agreement_kinds, :tce_code, :string
    change_column :compras_checking_account_of_fiscal_accounts, :tce_code, :string
    change_column :compras_checking_account_structure_informations, :tce_code, :string
    change_column :compras_service_or_contract_types, :tce_code, :string
  end
end
