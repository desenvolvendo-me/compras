class RemoveSpecialEntries < ActiveRecord::Migration
  def change
    drop_table :compras_special_entries
  end
end
