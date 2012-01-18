class CreateIndexers < ActiveRecord::Migration
  def change
    create_table :indexers do |t|
      t.string :name
      t.references :currency
      t.date :period_start
      t.date :period_end
      t.decimal :value, :precision => 10, :scale => 4

      t.timestamps
    end

    add_foreign_key :indexers, :currencies
  end
end
