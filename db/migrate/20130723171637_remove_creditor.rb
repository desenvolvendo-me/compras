class RemoveCreditor < ActiveRecord::Migration
  def change
    drop_table :compras_creditors
  end
end
