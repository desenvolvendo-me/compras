class AddClosingOfAccreditationToTrading < ActiveRecord::Migration
  def change
    add_column :compras_tradings, :closing_of_accreditation, :text
  end
end
