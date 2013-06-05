class RemoveTableLegalTextNature < ActiveRecord::Migration
  def up
    remove_column :compras_regulatory_acts, :legal_text_nature_id
  end

  def down
    drop_table :compras_legal_text_natures
  end
end
