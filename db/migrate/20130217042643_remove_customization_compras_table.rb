class RemoveCustomizationComprasTable < ActiveRecord::Migration
  def change
    unless Customization.table_exists?
      rename_table :compras_customizations, :financeiro_customizations
      rename_table :compras_customization_data, :financeiro_customization_data
    end
  end
end
