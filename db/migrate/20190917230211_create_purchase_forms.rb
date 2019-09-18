class CreatePurchaseForms < ActiveRecord::Migration
  def change
    create_table :compras_purchase_forms do |t|
      t.string :number
      t.string :budget_allocation

      t.timestamps
    end
  end
end
