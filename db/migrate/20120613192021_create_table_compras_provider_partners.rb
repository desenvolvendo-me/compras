class CreateTableComprasProviderPartners < ActiveRecord::Migration
  def change
    create_table "compras_provider_partners" do |t|
      t.integer  "provider_id"
      t.integer  "individual_id"
      t.string   "function"
      t.date     "date"
      t.datetime "created_at",    :null => false
      t.datetime "updated_at",    :null => false
    end

    add_index "compras_provider_partners", ["individual_id"], :name => "cpp_individual_id"
    add_index "compras_provider_partners", ["provider_id"], :name => "cpp_provider_id"
  end
end
