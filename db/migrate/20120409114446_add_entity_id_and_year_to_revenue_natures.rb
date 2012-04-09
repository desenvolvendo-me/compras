class AddEntityIdAndYearToRevenueNatures < ActiveRecord::Migration
  def change
    change_table :revenue_natures do |t|
      t.references :entity
      t.integer :year
    end

    add_index :revenue_natures, :entity_id

    add_foreign_key :revenue_natures, :entities
  end
end
