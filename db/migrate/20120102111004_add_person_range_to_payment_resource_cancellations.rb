class AddPersonRangeToPaymentResourceCancellations < ActiveRecord::Migration
  def change
    add_column :payment_resource_cancellations, :person_range, :string
  end
end
