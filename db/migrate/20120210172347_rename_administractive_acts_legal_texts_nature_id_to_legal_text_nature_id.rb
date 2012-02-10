class RenameAdministractiveActsLegalTextsNatureIdToLegalTextNatureId < ActiveRecord::Migration
  def change
    rename_column :administractive_acts, :legal_texts_nature_id, :legal_text_nature_id
  end
end
