class CreatePaymentAccounteds < ActiveRecord::Migration
  def change
    create_table :payment_accounteds do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
  end
end
