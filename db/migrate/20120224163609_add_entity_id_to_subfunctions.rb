class AddEntityIdToSubfunctions < ActiveRecord::Migration
  def change
    add_column :subfunctions, :entity_id, :integer
    add_index :subfunctions, :entity_id
    add_foreign_key :subfunctions, :entities
  end
end
