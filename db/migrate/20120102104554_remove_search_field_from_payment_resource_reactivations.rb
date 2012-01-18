class RemoveSearchFieldFromPaymentResourceReactivations < ActiveRecord::Migration
  def change
    remove_column :payment_resource_reactivations, :search_field
  end
end
