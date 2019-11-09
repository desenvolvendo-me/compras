class CreatePledgeRequestPurchaseSolicitations < ActiveRecord::Migration
  def change
    create_table :compras_pledge_request_purchase_solicitations do |t|
      t.references :pledge_request
      t.references :purchase_solicitation

      t.timestamps
    end
    add_index :compras_pledge_request_purchase_solicitations,
              :pledge_request_id,name: :cprps_pledge_request_fk
    add_foreign_key :compras_pledge_request_purchase_solicitations,
                    :compras_pledge_requests,column: :pledge_request_id,
                    name: :cprps_pledge_request_fk


    add_index :compras_pledge_request_purchase_solicitations,
              :purchase_solicitation_id,name: :cprps_purchase_solicitation_fk
    add_foreign_key :compras_pledge_request_purchase_solicitations,
                    :compras_purchase_solicitations,column: :purchase_solicitation_id,
                    name: :cprps_purchase_solicitation_fk
  end
end
