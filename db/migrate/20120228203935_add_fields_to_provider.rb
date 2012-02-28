class AddFieldsToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :property_id, :integer
    add_column :providers, :agency_id, :integer
    add_column :providers, :legal_nature_id, :integer
    add_column :providers, :cnae_id, :integer
    add_column :providers, :registration_date, :date
    add_column :providers, :bank_account, :string
    add_column :providers, :crc_number, :string
    add_column :providers, :crc_registration_date, :date
    add_column :providers, :crc_expiration_date, :date
    add_column :providers, :crc_renewal_date, :date

    add_index :providers, :property_id
    add_index :providers, :agency_id
    add_index :providers, :legal_nature_id
    add_index :providers, :cnae_id

    add_foreign_key :providers, :properties
    add_foreign_key :providers, :agencies
    add_foreign_key :providers, :legal_natures
    add_foreign_key :providers, :cnaes
  end
end
