class CreateComprasSettings < ActiveRecord::Migration
  def change
    create_table :compras_settings do |t|
      t.references :prefecture
      t.boolean :allow_insert_past_processes
    end

    add_index :compras_settings, :prefecture_id
    add_foreign_key :compras_settings, :unico_prefectures, :column => :prefecture_id
  end
end
