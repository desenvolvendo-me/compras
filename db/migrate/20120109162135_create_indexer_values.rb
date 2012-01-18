class CreateIndexerValues < ActiveRecord::Migration
  def change
    create_table :indexer_values do |t|
      t.date :period_start
      t.date :period_end
      t.decimal :value, :precision => 10, :scale => 2
      t.integer :indexer_id

      t.timestamps
    end
    add_index :indexer_values, :indexer_id
    add_foreign_key :indexer_values, :indexers
  end
end
