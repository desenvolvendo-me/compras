class ChangeOriginAndStatusToStringOnPaymentResources < ActiveRecord::Migration
  def change
    remove_index :payment_resources, :origin
    remove_index :payment_resources, :status
    remove_column :payment_resources, :origin
    remove_column :payment_resources, :status
    add_column :payment_resources, :origin, :string
    add_column :payment_resources, :status, :string
  end
end
