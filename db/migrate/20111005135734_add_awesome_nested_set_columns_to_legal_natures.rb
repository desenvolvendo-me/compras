class AddAwesomeNestedSetColumnsToLegalNatures < ActiveRecord::Migration
  def change
    add_column :legal_natures, :lft, :integer
    add_column :legal_natures, :rgt, :integer
    add_column :legal_natures, :parent_id, :integer

    add_index :legal_natures, :parent_id
    add_foreign_key :legal_natures, :legal_natures, :column => :parent_id
  end
end
