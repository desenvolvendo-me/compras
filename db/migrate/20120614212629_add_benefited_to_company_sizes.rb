class AddBenefitedToCompanySizes < ActiveRecord::Migration
  def change
    add_column :unico_company_sizes, :benefited, :boolean, :default => false
  end
end
