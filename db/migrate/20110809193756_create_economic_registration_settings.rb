class CreateEconomicRegistrationSettings < ActiveRecord::Migration
  def change
    create_table :economic_registration_settings do |t|
      t.string :year
      t.references :economic_registration

      t.timestamps
    end
    add_index :economic_registration_settings, :economic_registration_id, :name => "economic_registration_idx"
    add_foreign_key :economic_registration_settings, :economic_registrations, :name => "economic_registration_settins_fk"
  end
end
