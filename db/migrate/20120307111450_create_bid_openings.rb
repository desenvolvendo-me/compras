class CreateBidOpenings < ActiveRecord::Migration
  def change
    create_table :bid_openings do |t|
      t.integer :process
      t.integer :year
      t.date :date
      t.string :protocol
      t.integer :organogram_id
      t.decimal :value_estimated, :preficion => 10, :scale => 2
      t.integer :budget_allocation_id
      t.string :modality
      t.string :item
      t.string :object_type
      t.text :description
      t.integer :responsible_id
      t.string :bid_opening_status
      t.date :delivery_date

      t.timestamps
    end

    add_index :bid_openings, :organogram_id
    add_index :bid_openings, :budget_allocation_id
    add_index :bid_openings, :responsible_id

    add_foreign_key :bid_openings, :organograms
    add_foreign_key :bid_openings, :budget_allocations
    add_foreign_key :bid_openings, :employees, :column => :responsible_id
  end
end
