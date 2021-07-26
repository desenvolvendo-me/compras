class AddCustomDataToRegulatoryActTypes < ActiveRecord::Migration
  def change
    add_column :compras_regulatory_act_types, :custom_data, :hstore
  end
end
