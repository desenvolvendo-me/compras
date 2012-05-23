class AddCompanyToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :company_id, :integer

    add_index :partners, :company_id
    add_foreign_key :partners, :companies
  end
end
