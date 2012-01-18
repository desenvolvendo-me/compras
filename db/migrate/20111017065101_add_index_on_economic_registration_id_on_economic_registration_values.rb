class AddIndexOnEconomicRegistrationIdOnEconomicRegistrationValues < ActiveRecord::Migration
  def change
    add_index :economic_registration_values, :economic_registration_id
  end
end
