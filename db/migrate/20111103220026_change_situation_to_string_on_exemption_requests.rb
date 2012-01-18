class ChangeSituationToStringOnExemptionRequests < ActiveRecord::Migration
  def change
    remove_column :exemption_requests, :situation
    add_column :exemption_requests, :situation, :string
  end
end
