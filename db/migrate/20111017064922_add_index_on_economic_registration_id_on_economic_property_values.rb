class AddIndexOnEconomicRegistrationIdOnEconomicPropertyValues < ActiveRecord::Migration
  def change
    add_index :economic_property_values, :economic_registration_id
  end
end
