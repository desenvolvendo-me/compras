class AddYearToPledgeHistorics < ActiveRecord::Migration
  def change
    add_column :pledge_historics, :year, :integer
  end
end
