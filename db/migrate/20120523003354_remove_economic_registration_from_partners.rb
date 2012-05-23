class RemoveEconomicRegistrationFromPartners < ActiveRecord::Migration
  def change
    remove_column :partners, :economic_registration_id
  end
end
