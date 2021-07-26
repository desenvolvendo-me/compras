class CreateTableComprasExtraCreditNatures < ActiveRecord::Migration
  def change
    create_table "compras_extra_credit_natures" do |t|
      t.string   "description"
      t.string   "kind"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end
  end
end
