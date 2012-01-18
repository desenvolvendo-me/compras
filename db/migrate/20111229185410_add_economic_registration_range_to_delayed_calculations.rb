class AddEconomicRegistrationRangeToDelayedCalculations < ActiveRecord::Migration
  def change
    add_column :delayed_calculations, :economic_registration_range, :string
  end
end
