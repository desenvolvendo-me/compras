class RemoveBank < ActiveRecord::Migration
  def change
    drop_table :compras_banks
  end
end
