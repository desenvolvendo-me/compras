class ChangeCommitmentTypeCodeToString < ActiveRecord::Migration
  def up
    change_column :commitment_types, :code, :string
  end

  def down
    change_column :commitment_types, :code, :integer
  end
end
