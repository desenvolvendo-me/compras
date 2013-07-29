class RemoveAgency < ActiveRecord::Migration
  def change
    drop_table :compras_agencies
  end
end
