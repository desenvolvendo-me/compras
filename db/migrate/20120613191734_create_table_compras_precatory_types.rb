class CreateTableComprasPrecatoryTypes < ActiveRecord::Migration
  def change
    create_table "compras_precatory_types" do |t|
      t.string   "description"
      t.string   "status"
      t.date     "deactivation_date"
      t.datetime "created_at",        :null => false
      t.datetime "updated_at",        :null => false
    end
  end
end
