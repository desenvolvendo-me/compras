class AddColumnsPenaltyFineAndDefaultFineToContracts < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :penalty_fine, :string
    add_column :compras_contracts, :default_fine, :string
  end
end
