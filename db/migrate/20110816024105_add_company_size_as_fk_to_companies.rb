class AddCompanySizeAsFkToCompanies < ActiveRecord::Migration
  def change
    add_foreign_key :companies, :company_sizes
  end
end
