class CreateTableComprasUsers < ActiveRecord::Migration
  def change
    create_table "compras_users" do |t|
      t.string   "name"
      t.string   "email",                                 :default => "",    :null => false
      t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
      t.datetime "created_at",                                               :null => false
      t.datetime "updated_at",                                               :null => false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.integer  "profile_id"
      t.string   "login"
      t.boolean  "administrator",                         :default => false
      t.integer  "authenticable_id"
      t.string   "authenticable_type"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
    end

    add_index "compras_users", ["confirmation_token"], :name => "cu_confirmation_token"
    add_index "compras_users", ["login"], :name => "cu_login"
    add_index "compras_users", ["profile_id"], :name => "cu_profile_id"
  end
end
