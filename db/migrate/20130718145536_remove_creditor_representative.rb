class RemoveCreditorRepresentative < ActiveRecord::Migration
  def change
    drop_table :compras_creditor_representatives
  end
end
