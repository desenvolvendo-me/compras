class AddControlAmountToMaterials < ActiveRecord::Migration
  def change
    add_column :compras_materials, :control_amount, :boolean, :default => false
  end
end
