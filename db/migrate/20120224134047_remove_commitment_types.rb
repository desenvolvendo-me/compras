class RemoveCommitmentTypes < ActiveRecord::Migration
  def change
    drop_table :commitment_types
  end
end
