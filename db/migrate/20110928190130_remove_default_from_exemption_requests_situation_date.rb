class RemoveDefaultFromExemptionRequestsSituationDate < ActiveRecord::Migration
  def change
    change_column_default :exemption_requests, :situation_date, nil
  end
end
