class CreateSpecialEntries < ActiveRecord::Migration
  def change
    create_table :compras_special_entries do |t|
      t.string :name

      t.timestamps
    end
  end
end
