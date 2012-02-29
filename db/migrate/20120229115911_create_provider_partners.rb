class CreateProviderPartners < ActiveRecord::Migration
  def change
    create_table :provider_partners do |t|
      t.references :provider
      t.references :individual
      t.string :function
      t.date :date

      t.timestamps
    end

    add_index :provider_partners, :provider_id
    add_index :provider_partners, :individual_id
    add_foreign_key :provider_partners, :providers
    add_foreign_key :provider_partners, :individuals
  end
end
