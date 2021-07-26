class CreateElectronicAuction < ActiveRecord::Migration
  def change
    create_table "compras_auctions" do |t|
      t.string  "auction_type"
      t.string  "licitation_number"
      t.string  "process_number"
      t.integer "year"
      t.string  "dispute_type"
      t.string  "judment_form"
      t.boolean "covid_law"
      t.decimal "purchase_value", precision: 16, scale: 2
      t.integer "items_quantity"
      t.text    "object"
      t.string  "object_management"
      t.integer 'employee_id'
    end

    add_index :compras_auctions, :employee_id
    add_foreign_key :compras_auctions, :compras_employees,
                    column: :employee_id
  end
end
