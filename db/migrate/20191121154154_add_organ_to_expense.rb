class AddOrganToExpense < ActiveRecord::Migration
  def change
    add_column :compras_expenses,
               :unity_id, :integer
    add_index :compras_expenses, :unity_id
    add_foreign_key :compras_expenses, :compras_organs,
                    :column => :unity_id
  end
end
