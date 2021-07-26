class AddParentIdToRegulatoryActs < ActiveRecord::Migration
  def change
    add_column :compras_regulatory_acts, :parent_id, :integer

    add_index :compras_regulatory_acts, :parent_id
    add_foreign_key :compras_regulatory_acts, :compras_regulatory_acts, column: :parent_id
  end
end
