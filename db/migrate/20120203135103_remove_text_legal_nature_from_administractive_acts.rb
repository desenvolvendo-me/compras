class RemoveTextLegalNatureFromAdministractiveActs < ActiveRecord::Migration
  def change
    remove_column :administractive_acts, :text_legal_nature
  end
end
