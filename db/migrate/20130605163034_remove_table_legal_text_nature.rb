class RemoveTableLegalTextNature < ActiveRecord::Migration
  def change
    remove_column :compras_regulatory_acts, :legal_text_nature_id

    drop_table :compras_legal_text_natures
  end
end
