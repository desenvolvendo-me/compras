class CreateDebtPaymentResources < ActiveRecord::Migration
  def change
    create_table :debt_payment_resources do |t|
      t.references :payment_resource
      t.date :due_date
      t.boolean :single_parcel

      t.timestamps
    end
    add_index :debt_payment_resources, :payment_resource_id
    add_foreign_key :debt_payment_resources, :payment_resources
  end
end
