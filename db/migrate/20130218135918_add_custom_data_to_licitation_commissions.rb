class AddCustomDataToLicitationCommissions < ActiveRecord::Migration
  def change
    add_column :compras_licitation_commissions, :custom_data, :hstore
  end
end
