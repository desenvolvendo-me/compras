class CreatePledgeHistorics < ActiveRecord::Migration
  def change
    create_table :pledge_historics do |t|
      t.string :description
      t.references :entity

      t.timestamps
    end

    add_index :pledge_historics, :entity_id
    add_foreign_key :pledge_historics, :entities
  end
end
