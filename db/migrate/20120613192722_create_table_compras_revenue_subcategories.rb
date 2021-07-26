class CreateTableComprasRevenueSubcategories < ActiveRecord::Migration
  def change
    create_table "compras_revenue_subcategories" do |t|
      t.string   "code"
      t.string   "description"
      t.integer  "revenue_category_id"
      t.datetime "created_at",          :null => false
      t.datetime "updated_at",          :null => false
    end

    add_index "compras_revenue_subcategories", ["revenue_category_id"], :name => "crs_revenue_category_id"
  end
end
