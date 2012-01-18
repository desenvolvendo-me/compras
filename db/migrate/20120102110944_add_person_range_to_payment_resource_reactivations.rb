class AddPersonRangeToPaymentResourceReactivations < ActiveRecord::Migration
  def change
    add_column :payment_resource_reactivations, :person_range, :string
  end
end
