class AddEntityAndYearToPledgeCancellations < ActiveRecord::Migration
  def change
    change_table :pledge_cancellations do |t|
      t.integer :entity_id
      t.integer :year
    end

    add_index :pledge_cancellations, :entity_id

    add_foreign_key :pledge_cancellations, :entities
  end
end
