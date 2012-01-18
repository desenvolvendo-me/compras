class CreateRevenuePaymentResources < ActiveRecord::Migration
  def change
    create_table :revenue_payment_resources do |t|
      t.references :payment_resource
      t.references :revenue
      t.references :exemption
      t.decimal :payment_resource_value, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :revenue_payment_resources, :payment_resource_id
    add_index :revenue_payment_resources, :revenue_id
    add_index :revenue_payment_resources, :exemption_id
    add_foreign_key :revenue_payment_resources, :payment_resources
    add_foreign_key :revenue_payment_resources, :revenues
    add_foreign_key :revenue_payment_resources, :exemptions
  end
end
