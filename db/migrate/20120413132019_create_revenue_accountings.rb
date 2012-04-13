class CreateRevenueAccountings < ActiveRecord::Migration
  def change
    create_table :revenue_accountings do |t|
      t.references :entity
      t.integer :year
      t.string :code
      t.references :revenue_nature
      t.references :capability

      t.timestamps
    end

    add_index :revenue_accountings, :entity_id
    add_index :revenue_accountings, :revenue_nature_id
    add_index :revenue_accountings, :capability_id

    add_foreign_key :revenue_accountings, :entities
    add_foreign_key :revenue_accountings, :revenue_natures
    add_foreign_key :revenue_accountings, :capabilities
  end
end
