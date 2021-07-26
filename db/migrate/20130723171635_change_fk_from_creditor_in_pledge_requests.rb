class ChangeFkFromCreditorInPledgeRequests < ActiveRecord::Migration
  remove_foreign_key :compras_pledge_requests, column: :creditor_id
  add_foreign_key :compras_pledge_requests, :unico_creditors, column: :creditor_id
end
