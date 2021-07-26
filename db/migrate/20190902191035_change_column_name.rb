class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :compras_demands, :description, :name
    # rename_column :compras_demand_batches, :description, :name
    # rename_column :compras_batch_materials, :description, :name
  end
end
