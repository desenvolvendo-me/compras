class RenameLegalTextsNaturesToLegalTextNatures < ActiveRecord::Migration
  def change
    rename_table :legal_texts_natures, :legal_text_natures
  end
end
