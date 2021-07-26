class RemoteHistoricComplementFromPledgeRequests < ActiveRecord::Migration
  def change
    remove_column :compras_pledge_requests, :historic_complement
  end
end
