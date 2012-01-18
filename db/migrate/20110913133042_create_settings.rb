class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key
      t.integer :value

      t.timestamps
    end
    add_index :settings, :key
  end
end
