class AddBankInfoToCompanies < ActiveRecord::Migration
  def change
    add_column :unico_companies, :bank_info, :string
    add_column :unico_companies, :account_info, :string
    add_column :unico_companies, :agencie_info, :string
    add_column :unico_companies, :account_type, :string
  end
end
