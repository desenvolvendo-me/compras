class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :cnpj
      t.references :legal_nature
      t.references :person
      t.string :state_registration
      t.string :commercial_registration_number
      t.date :commercial_registration_date
      t.references :company_size
      t.boolean :choose_simple
      t.string :responsible_role
      t.string :phone
      t.string :fax
      t.string :mobile
      t.string :email

      t.timestamps
    end
    add_index :companies, :legal_nature_id
    add_index :companies, :person_id
    add_index :companies, :company_size_id
  end
end
