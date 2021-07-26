class CreateTableComprasRevenueCategories < ActiveRecord::Migration
  def change
    create_table "compras_revenue_categories" do |t|
      t.string   "code"
      t.string   "description"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end
  end
end
