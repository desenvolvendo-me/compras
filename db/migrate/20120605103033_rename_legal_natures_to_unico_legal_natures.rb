class RenameLegalNaturesToUnicoLegalNatures < ActiveRecord::Migration
  def change
    rename_table :legal_natures, :unico_legal_natures
  end
end
