class CreateTableComprasLegalTextNatures < ActiveRecord::Migration
  def change
    create_table "compras_legal_text_natures" do |t|
      t.string   "description"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end
  end
end
