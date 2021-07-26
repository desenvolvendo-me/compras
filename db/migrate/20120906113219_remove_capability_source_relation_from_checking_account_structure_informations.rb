class RemoveCapabilitySourceRelationFromCheckingAccountStructureInformations < ActiveRecord::Migration
  def change
    remove_column :compras_checking_account_structure_informations, :capability_source_id
  end
end
