class RemoveAdministrationTypes < ActiveRecord::Migration
  def change
    remove_column :compras_budget_structures, :administration_type_id
    drop_table :compras_administration_types
  end
end
