class RemoveRelationshipBetweenContractTerminationAndDisseminationSource < ActiveRecord::Migration
  def change
    remove_column :compras_contract_terminations, :dissemination_source_id
  end
end
