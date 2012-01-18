class CreateRevenueDebtPaymentResources < ActiveRecord::Migration
  def change
    create_table :revenue_debt_payment_resources do |t|
      t.references :debt_payment_resource
      t.references :revenue
      t.decimal :generated_value, :precision => 10, :scale => 2
      t.decimal :discount_value, :precision => 10, :scale => 2
      t.decimal :base_value, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :revenue_debt_payment_resources, :debt_payment_resource_id, :name => 'index_revenue_debt_payment_resources_on_debt_payment_resource'
    add_index :revenue_debt_payment_resources, :revenue_id
    add_foreign_key :revenue_debt_payment_resources, :debt_payment_resources
    add_foreign_key :revenue_debt_payment_resources, :revenues
  end
end
