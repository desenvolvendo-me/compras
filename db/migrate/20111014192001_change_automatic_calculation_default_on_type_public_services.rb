class ChangeAutomaticCalculationDefaultOnTypePublicServices < ActiveRecord::Migration
  def up
    change_column_default :type_public_services, :automatic_calculation, false
  end

  def down
    change_column_default :type_public_services, :automatic_calculation, nil
  end
end
