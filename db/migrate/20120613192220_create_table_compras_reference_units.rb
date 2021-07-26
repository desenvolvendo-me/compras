class CreateTableComprasReferenceUnits < ActiveRecord::Migration
  def change
    create_table "compras_reference_units" do |t|
      t.string   "name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string   "acronym"
    end
  end
end
