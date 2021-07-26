class SetSubcontractingDefaultValueToFalse < ActiveRecord::Migration
  def change
    change_column :compras_contracts, :subcontracting, :boolean, :default => false
  end
end
