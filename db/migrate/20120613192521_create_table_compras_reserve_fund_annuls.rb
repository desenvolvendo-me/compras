class CreateTableComprasReserveFundAnnuls < ActiveRecord::Migration
  def change
    create_table "compras_reserve_fund_annuls" do |t|
      t.integer  "reserve_fund_id"
      t.integer  "employee_id"
      t.date     "date"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
    end

    add_index "compras_reserve_fund_annuls", ["employee_id"], :name => "crfa_employee_id"
    add_index "compras_reserve_fund_annuls", ["reserve_fund_id"], :name => "crfa_reserve_fund_id"
  end
end
