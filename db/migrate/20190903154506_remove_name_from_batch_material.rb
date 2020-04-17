class RemoveNameFromBatchMaterial < ActiveRecord::Migration
  def up
    # remove_column :compras_batch_materials, :name
  end

  def down
    add_column :compras_batch_materials, :name, :string
  end
end
