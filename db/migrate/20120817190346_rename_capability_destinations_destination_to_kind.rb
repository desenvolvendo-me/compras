class RenameCapabilityDestinationsDestinationToKind < ActiveRecord::Migration
  def change
    rename_column :compras_capability_destinations, :destination, :kind
  end
end
