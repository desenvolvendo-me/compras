class RemoveProcessNumberFromContracts < ActiveRecord::Migration
  def change
    remove_column :compras_contracts, :process_number
  end
end
