class CreateJudicialDocumentTypes < ActiveRecord::Migration
  def change
    create_table :judicial_document_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
