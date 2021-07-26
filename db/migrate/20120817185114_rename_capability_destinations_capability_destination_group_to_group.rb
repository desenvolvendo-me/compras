class RenameCapabilityDestinationsCapabilityDestinationGroupToGroup < ActiveRecord::Migration
  def change
    rename_column :compras_capability_destinations, :capability_destination_group, :group
  end
end
