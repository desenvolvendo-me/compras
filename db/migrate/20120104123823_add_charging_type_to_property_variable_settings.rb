class AddChargingTypeToPropertyVariableSettings < ActiveRecord::Migration
  def up
    add_column :property_variable_settings, :charging_type, :string

    #PropertyVariableSetting.find_each do |property_variable_setting|
      #charging_type = if property_variable_setting.predial?
                        #ChargingType::BUILDING
                      #else
                        #ChargingType::TERRITORIAL
                      #end

      #property_variable_setting.update_column(:charging_type, charging_type)
    #end
  end

  def down
    remove_column :property_variable_settings, :charging_type
  end
end
