class CreateSupplyRequests < ActiveRecord::Migration
  def change
    create_table :compras_supply_requests do |t|
      t.date :authorization_date
      t.integer :licitation_process_id
      t.integer :year
      t.integer :pledge_id
      t.integer :creditor_id
      t.integer :purchase_solicitation_id
      t.boolean :updatabled
      t.integer :contract_id

      t.timestamps
    end
  end
end
