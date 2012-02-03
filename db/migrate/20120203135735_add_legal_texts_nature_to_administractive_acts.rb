class AddLegalTextsNatureToAdministractiveActs < ActiveRecord::Migration
  def change
    add_column :administractive_acts, :legal_texts_nature_id, :integer
    add_index :administractive_acts, :legal_texts_nature_id
    add_foreign_key :administractive_acts, :legal_texts_natures
  end
end
