class RemoveRelationshipBetweenCreditorAndLicitationProcessRatification < ActiveRecord::Migration
  def change
    remove_column :compras_licitation_process_ratifications, :creditor_id
  end
end
