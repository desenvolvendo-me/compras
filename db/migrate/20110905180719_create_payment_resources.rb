class CreatePaymentResources < ActiveRecord::Migration
  def change
    create_table :payment_resources do |t|
      t.integer :year

      t.timestamps
    end
  end
end
