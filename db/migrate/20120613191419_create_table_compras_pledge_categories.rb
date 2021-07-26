class CreateTableComprasPledgeCategories < ActiveRecord::Migration
  def change
    create_table "compras_pledge_categories" do |t|
      t.string   "description"
      t.string   "status"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
      t.string   "source"
    end
  end
end
