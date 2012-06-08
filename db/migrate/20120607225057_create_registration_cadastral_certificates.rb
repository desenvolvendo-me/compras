class CreateRegistrationCadastralCertificates < ActiveRecord::Migration
  def change
    create_table :registration_cadastral_certificates do |t|
      t.references :creditor
      t.integer :fiscal_year
      t.integer :number
      t.text :specification
      t.date :registration_date
      t.date :validity_date
      t.date :revocation_date
      t.decimal :capital_stock, :precision => 20, :scale => 2
      t.decimal :capital_whole, :precision => 20, :scale => 2
      t.decimal :total_sales,   :precision => 20, :scale => 2
      t.decimal :building_area, :precision => 10, :scale => 2
      t.decimal :total_area,    :precision => 10, :scale => 2
      t.integer :total_employees
      t.date :commercial_registry_registration_date
      t.string :commercial_registry_number

      t.timestamps
    end

    add_index :registration_cadastral_certificates, :creditor_id
    add_foreign_key :registration_cadastral_certificates, :creditors
  end
end
