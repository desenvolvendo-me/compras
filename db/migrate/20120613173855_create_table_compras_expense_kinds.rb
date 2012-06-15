class CreateTableComprasExpenseKinds < ActiveRecord::Migration
  def change
    create_table "compras_expense_kinds" do |t|
      t.string   "description"
      t.string   "status"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end
  end
end
