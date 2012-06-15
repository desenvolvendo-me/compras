class CreateTableComprasDocumentTypes < ActiveRecord::Migration
  def change
    create_table "compras_document_types" do |t|
      t.integer  "validity"
      t.string   "description"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end
  end
end
