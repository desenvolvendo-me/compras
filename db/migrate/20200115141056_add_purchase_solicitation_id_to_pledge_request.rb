class AddPurchaseSolicitationIdToPledgeRequest < ActiveRecord::Migration
  def change
    add_column :compras_pledge_requests, :purchase_solicitation_id, :integer
  end
end
