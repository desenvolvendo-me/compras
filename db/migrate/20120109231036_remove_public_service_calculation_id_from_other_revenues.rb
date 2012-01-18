class RemovePublicServiceCalculationIdFromOtherRevenues < ActiveRecord::Migration
  def change
    remove_column :other_revenues, :public_service_calculation_id
  end
end
