class AddEntityYearToPledgeLiquidationCancellation < ActiveRecord::Migration
  def change
    change_table :pledge_liquidation_cancellations do |t|
      t.integer :entity_id
      t.integer :year
    end

    add_index :pledge_liquidation_cancellations, :entity_id
    add_foreign_key :pledge_liquidation_cancellations, :entities
  end
end
