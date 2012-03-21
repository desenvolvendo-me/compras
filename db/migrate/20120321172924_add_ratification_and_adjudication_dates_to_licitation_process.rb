class AddRatificationAndAdjudicationDatesToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :licitation_processes, :ratification_date, :date
    add_column :licitation_processes, :adjudication_date, :date
  end
end
