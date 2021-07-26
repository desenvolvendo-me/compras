class CreateTableComprasCustomers < ActiveRecord::Migration
  def change
    create_table "compras_customers" do |t|
      t.string   "name"
      t.string   "domain"
      t.string   "database"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "compras_customers", ["domain"], :name => "cc_domain"
  end
end
