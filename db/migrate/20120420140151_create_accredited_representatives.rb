class CreateAccreditedRepresentatives < ActiveRecord::Migration
  def change
    create_table :accredited_representatives do |t|
      t.references :accreditation
      t.references :individual
      t.references :provider
      t.string :role

      t.timestamps
    end

    add_index :accredited_representatives, :accreditation_id
    add_index :accredited_representatives, :individual_id
    add_index :accredited_representatives, :provider_id

    add_foreign_key :accredited_representatives, :accreditations
    add_foreign_key :accredited_representatives, :individuals
    add_foreign_key :accredited_representatives, :providers
  end
end
