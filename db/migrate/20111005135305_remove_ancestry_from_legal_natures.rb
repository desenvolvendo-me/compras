class RemoveAncestryFromLegalNatures < ActiveRecord::Migration
  def up
    remove_column :legal_natures, :ancestry
  end

  def down
    add_column :legal_natures, :ancestry, :string
  end
end
