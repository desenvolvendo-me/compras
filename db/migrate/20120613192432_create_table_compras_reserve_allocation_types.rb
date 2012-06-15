class CreateTableComprasReserveAllocationTypes < ActiveRecord::Migration
  def change
    create_table "compras_reserve_allocation_types" do |t|
      t.string   "description"
      t.string   "status"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
      t.string   "source"
    end
  end
end
