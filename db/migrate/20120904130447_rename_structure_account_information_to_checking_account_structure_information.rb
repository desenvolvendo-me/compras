class RenameStructureAccountInformationToCheckingAccountStructureInformation < ActiveRecord::Migration
  def change
    rename_table :compras_structure_account_informations, :compras_checking_account_structure_informations
  end
end
