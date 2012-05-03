class AddTypeOfCalculationToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :licitation_processes, :type_of_calculation, :string

    lowest_global_price = LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE

    LicitationProcess.update_all(:type_of_calculation => lowest_global_price)
  end
end
