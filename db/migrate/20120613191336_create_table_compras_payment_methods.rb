class CreateTableComprasPaymentMethods < ActiveRecord::Migration
  def change
    create_table "compras_payment_methods" do |t|
      t.string   "description"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end
  end
end
