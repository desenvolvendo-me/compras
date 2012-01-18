class AddCompanyMinValueToAgreementOperation < ActiveRecord::Migration
  def change
    add_column :agreement_operations, :company_min_value, :decimal, :precision => 10, :scale => 2
  end
end
