class CreateSubpledgeExpirations < ActiveRecord::Migration
  def change
    create_table :subpledge_expirations do |t|
      t.date :expiration_date
      t.decimal :value, :precision => 10, :scale => 2
      t.references :subpledge
      t.integer :number

      t.timestamps
    end

    add_index :subpledge_expirations, :subpledge_id

    add_foreign_key :subpledge_expirations, :subpledges
  end
end
