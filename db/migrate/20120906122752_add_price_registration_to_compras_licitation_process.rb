class AddPriceRegistrationToComprasLicitationProcess < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :price_registration, :boolean, :default => false
  end
end
