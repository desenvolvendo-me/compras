class RemoveDefaultFromExemptionRequestsDate < ActiveRecord::Migration
  def change
    change_column_default :exemption_requests, :date, nil
  end
end
