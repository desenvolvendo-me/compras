class AddPurchaseSolicitationIdPledgeRequestItem < ActiveRecord::Migration
  def up
    add_column :compras_pledge_request_items,
               :purchase_solicitation_id, :integer
    add_index :compras_pledge_request_items, :purchase_solicitation_id
    add_foreign_key :compras_pledge_request_items,
                    :compras_purchase_solicitations,
                    column: :purchase_solicitation_id
  end

  def down
    remove_column :compras_pledge_request_items,
               :purchase_solicitation_id
  end
end