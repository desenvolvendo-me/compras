class CreateRevenueSources < ActiveRecord::Migration
  def change
    create_table :revenue_sources do |t|
      t.string :code
      t.string :description
      t.integer :revenue_nature_id

      t.timestamps
    end

    add_index :revenue_sources, :revenue_nature_id

    add_foreign_key :revenue_sources, :revenue_natures
  end
end
