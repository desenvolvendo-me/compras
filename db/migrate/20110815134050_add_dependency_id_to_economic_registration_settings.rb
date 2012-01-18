class AddDependencyIdToEconomicRegistrationSettings < ActiveRecord::Migration
  def change
    add_column :economic_registration_settings, :dependency_id, :integer
    add_index :economic_registration_settings, :dependency_id
    add_foreign_key :economic_registration_settings, :economic_registration_settings, :column => :dependency_id
  end
end
