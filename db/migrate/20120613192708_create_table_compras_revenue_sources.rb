class CreateTableComprasRevenueSources < ActiveRecord::Migration
  def change
    create_table "compras_revenue_sources" do |t|
      t.string   "code"
      t.string   "description"
      t.integer  "revenue_subcategory_id"
      t.datetime "created_at",             :null => false
      t.datetime "updated_at",             :null => false
    end

    add_index "compras_revenue_sources", ["revenue_subcategory_id"], :name => "crs_revenue_subcategory_id"
  end
end
