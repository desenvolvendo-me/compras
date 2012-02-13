class AddStnOrdinanceToEconomicClassificationOfExpenditure < ActiveRecord::Migration
  def change
    add_column :economic_classification_of_expenditures, :stn_ordinance_id, :integer
    add_index :economic_classification_of_expenditures, :stn_ordinance_id, :name => :ecoe_stn_ordinance_id
    add_foreign_key :economic_classification_of_expenditures, :stn_ordinances, :name => :ecoe_stn_ordinance_fk
  end
end
