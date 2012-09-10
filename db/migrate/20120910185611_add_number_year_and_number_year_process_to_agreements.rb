class AddNumberYearAndNumberYearProcessToAgreements < ActiveRecord::Migration
  def change
    change_table :compras_agreements do |t|
      t.string :number_year
      t.string :number_year_process
    end
  end
end
