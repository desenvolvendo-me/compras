class AddModelRequestToPurchaseSolicitation < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitations,
               :model_request, :boolean
  end
end