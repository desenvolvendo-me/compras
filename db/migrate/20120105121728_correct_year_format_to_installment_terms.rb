class CorrectYearFormatToInstallmentTerms < ActiveRecord::Migration
  def up
    change_column :installment_terms, :year, :string
  end

  def down
    change_column :installment_terms, :year, :integer
  end
end
