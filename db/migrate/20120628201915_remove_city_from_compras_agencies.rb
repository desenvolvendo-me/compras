class RemoveCityFromComprasAgencies < ActiveRecord::Migration
  def change
    remove_foreign_key :compras_agencies, :name => "agencies_city_id_fk"
    remove_index :compras_agencies, :name => "ca_city_id"
    remove_column :compras_agencies, :city_id
  end
end
