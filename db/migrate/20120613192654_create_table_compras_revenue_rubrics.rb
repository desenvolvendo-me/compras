class CreateTableComprasRevenueRubrics < ActiveRecord::Migration
  def change
    create_table "compras_revenue_rubrics" do |t|
      t.string   "code"
      t.string   "description"
      t.integer  "revenue_source_id"
      t.datetime "created_at",        :null => false
      t.datetime "updated_at",        :null => false
    end

    add_index "compras_revenue_rubrics", ["revenue_source_id"], :name => "crr_revenue_source_id"
  end
end
