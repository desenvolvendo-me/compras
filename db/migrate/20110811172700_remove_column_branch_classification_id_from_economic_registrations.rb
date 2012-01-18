class RemoveColumnBranchClassificationIdFromEconomicRegistrations < ActiveRecord::Migration
  def up
    remove_index :economic_registrations, :branch_classification_id
    remove_foreign_key :economic_registrations, :branch_classifications
    remove_column :economic_registrations, :branch_classification_id
  end

  def down
    add_index :economic_registrations, :branch_classification_id
    add_foreign_key :economic_registrations, :branch_classifications
    add_column :economic_registrations, :branch_classification_id, :integer
  end
end
