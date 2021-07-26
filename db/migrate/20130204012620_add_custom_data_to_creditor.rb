class AddCustomDataToCreditor < ActiveRecord::Migration
  def change
    add_column :compras_creditors, :custom_data, :hstore
  end
end
