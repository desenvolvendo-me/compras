class CreateTableComprasRoles < ActiveRecord::Migration
  def change
    create_table "compras_roles" do |t|
      t.string   "controller"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string   "permission"
      t.integer  "profile_id"
    end

    add_index "compras_roles", ["profile_id"], :name => "cr_profile_id"
  end
end
