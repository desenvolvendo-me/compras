class CreateTableComprasFiscalYears < ActiveRecord::Migration
  def change
    create_table "compras_fiscal_years" do |t|
      t.integer  "year"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "compras_fiscal_years", ["year"], :name => "cfy_year"
  end
end
