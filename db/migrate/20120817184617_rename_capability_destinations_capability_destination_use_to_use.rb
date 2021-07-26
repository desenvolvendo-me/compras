class RenameCapabilityDestinationsCapabilityDestinationUseToUse < ActiveRecord::Migration
  def change
    rename_column :compras_capability_destinations, :capability_destination_use, :use
  end
end
