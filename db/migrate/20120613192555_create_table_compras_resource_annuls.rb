class CreateTableComprasResourceAnnuls < ActiveRecord::Migration
  def change
    create_table "compras_resource_annuls" do |t|
      t.integer  "employee_id"
      t.date     "date"
      t.text     "description"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
      t.integer  "annullable_id"
      t.string   "annullable_type"
    end

    add_index "compras_resource_annuls", ["annullable_id", "annullable_type"], :name => "cra_annullable_type"
    add_index "compras_resource_annuls", ["employee_id"], :name => "cra_employee_id"
  end
end
