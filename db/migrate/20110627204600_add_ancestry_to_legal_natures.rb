class AddAncestryToLegalNatures < ActiveRecord::Migration
  def change
    add_column :legal_natures, :ancestry, :string
    add_index :legal_natures, :ancestry
  end
end
