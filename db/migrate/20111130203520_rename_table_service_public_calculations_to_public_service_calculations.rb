class RenameTableServicePublicCalculationsToPublicServiceCalculations < ActiveRecord::Migration
  def change
    rename_table :service_public_calculations, :public_service_calculations
  end
end
