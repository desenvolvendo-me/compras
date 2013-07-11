class RemoveRelationshipBetweenAgreementsAndRegulatoryActs < ActiveRecord::Migration
  def change
    remove_column :compras_agreements, :regulatory_act_id
  end
end
