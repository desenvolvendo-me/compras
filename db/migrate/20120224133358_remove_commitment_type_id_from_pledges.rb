class RemoveCommitmentTypeIdFromPledges < ActiveRecord::Migration
  def change
    remove_column :pledges, :commitment_type_id
  end
end
