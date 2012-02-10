class RenameLegalTextsNatureNameToDescription < ActiveRecord::Migration
  def change
    rename_column :legal_texts_natures, :name, :description
  end
end
