class CreateSubpledgeCancellations < ActiveRecord::Migration
  def change
    create_table :subpledge_cancellations do |t|
      t.references :entity
      t.integer :year
      t.references :pledge
      t.references :subpledge
      t.decimal :value
      t.date :date
      t.text :reason

      t.timestamps
    end

    add_index :subpledge_cancellations, :entity_id
    add_index :subpledge_cancellations, :pledge_id
    add_index :subpledge_cancellations, :subpledge_id

    add_foreign_key :subpledge_cancellations, :entities
    add_foreign_key :subpledge_cancellations, :pledges
    add_foreign_key :subpledge_cancellations, :subpledges
  end
end
