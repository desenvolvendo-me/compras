class RemoveRelationshipBetweenLicitationComissionsAndRegulatoryActs < ActiveRecord::Migration
  def up
    remove_column :compras_licitation_commissions, :regulatory_act_id
  end
end
