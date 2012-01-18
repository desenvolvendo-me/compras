class AddLegalNatureAsFkToCompanies < ActiveRecord::Migration
  def change
    add_foreign_key :companies, :legal_natures
  end
end
