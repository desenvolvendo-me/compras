class AddPurchaseFormIdToPledgeRequest < ActiveRecord::Migration
  def change
    add_column :compras_pledge_requests, :purchase_form_id, :integer
  end
end
