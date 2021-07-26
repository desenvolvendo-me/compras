class AddFieldsToCustomizationData < ActiveRecord::Migration
  def change
    add_column :compras_customization_data, :required, :boolean, :default => false
  end
end
