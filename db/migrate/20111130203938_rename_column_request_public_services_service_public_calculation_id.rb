class RenameColumnRequestPublicServicesServicePublicCalculationId < ActiveRecord::Migration
  def change
    rename_column :request_public_services, :service_public_calculation_id, :public_service_calculation_id
  end
end
