class RemoveExpenseOrdinanceFromMaterials < ActiveRecord::Migration
  def change
    remove_column :materials, :expense_element
  end
end
