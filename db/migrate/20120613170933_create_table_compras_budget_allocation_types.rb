class CreateTableComprasBudgetAllocationTypes < ActiveRecord::Migration
  def change
    create_table "compras_budget_allocation_types" do |t|
      t.string   "description"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
      t.string   "source"
      t.string   "status"
    end
  end
end
