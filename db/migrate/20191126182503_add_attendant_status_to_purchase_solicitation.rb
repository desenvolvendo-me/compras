class AddAttendantStatusToPurchaseSolicitation < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitations,
               :attendant_status, :string
  end
end