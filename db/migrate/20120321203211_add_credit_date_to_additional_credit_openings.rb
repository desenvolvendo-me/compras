class AddCreditDateToAdditionalCreditOpenings < ActiveRecord::Migration
  def change
    add_column :additional_credit_openings, :credit_date, :date
  end
end
