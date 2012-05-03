class AddEntityAndYearToPledgeLiquidation < ActiveRecord::Migration
  def change
    change_table :pledge_liquidations do |t|
      t.references :entity
      t.integer :year
    end

    add_index :pledge_liquidations, :entity_id

    add_foreign_key :pledge_liquidations, :entities
  end
end
