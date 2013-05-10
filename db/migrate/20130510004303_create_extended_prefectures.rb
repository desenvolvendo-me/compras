class CreateExtendedPrefectures < ActiveRecord::Migration
  def change
    create_table :compras_extended_prefectures do |t|
      t.integer :prefecture_id, null: false
      t.string  :organ_code
      t.string  :organ_kind

      t.timestamps
    end

    add_index :compras_extended_prefectures, :prefecture_id

    add_foreign_key :compras_extended_prefectures, :unico_prefectures, column: :prefecture_id
  end
end
