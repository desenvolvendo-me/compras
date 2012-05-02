class AddTypeOfCalculationToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :licitation_processes, :type_of_calculation, :string

    LicitationProcess.find_each do |licitation_process|
      licitation_process.update_attribute(:type_of_calculation, LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE)
    end
  end
end
