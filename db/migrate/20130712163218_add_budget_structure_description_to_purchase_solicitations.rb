class AddBudgetStructureDescriptionToPurchaseSolicitations < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitations, :budget_structure_description, :string
  end
end
