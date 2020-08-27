class RemoveNumberYearAndNumberYearProcessAtAgreements < ActiveRecord::Migration
  def change
    remove_columns :compras_agreements, :number, :year, :process_number, :process_year
  end
end
