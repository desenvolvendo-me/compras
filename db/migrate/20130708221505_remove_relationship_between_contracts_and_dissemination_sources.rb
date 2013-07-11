class RemoveRelationshipBetweenContractsAndDisseminationSources < ActiveRecord::Migration
  def change
    remove_column :compras_contracts, :dissemination_source_id
  end
end
