class AddEconomicRegistrationIdToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :economic_registration_id, :integer

    add_index :providers, :economic_registration_id

    add_foreign_key :providers, :economic_registrations
  end
end
