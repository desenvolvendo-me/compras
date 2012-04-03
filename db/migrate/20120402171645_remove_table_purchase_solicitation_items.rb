class RemoveTablePurchaseSolicitationItems < ActiveRecord::Migration
  def change
    drop_table :purchase_solicitation_items
  end
end
