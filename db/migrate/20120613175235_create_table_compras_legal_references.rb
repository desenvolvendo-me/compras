class CreateTableComprasLegalReferences < ActiveRecord::Migration
  def change
    create_table "compras_legal_references" do |t|
      t.string   "description"
      t.string   "law"
      t.string   "article"
      t.string   "paragraph"
      t.string   "sections"
      t.text     "synopsis"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end
  end
end
