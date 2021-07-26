class RemoveRelationshipBetweenContractAdditiveAndDisseminationSource < ActiveRecord::Migration
  def change
    remove_column :compras_contract_additives, :dissemination_source_id
  end
end
