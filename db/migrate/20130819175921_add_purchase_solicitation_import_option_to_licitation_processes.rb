class AddPurchaseSolicitationImportOptionToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :purchase_solicitation_import_option, :string
  end
end
