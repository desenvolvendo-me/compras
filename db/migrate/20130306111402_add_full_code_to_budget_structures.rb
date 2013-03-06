class AddFullCodeToBudgetStructures < ActiveRecord::Migration
  def change
    add_column :compras_budget_structures, :full_code, :string

    begin
      BudgetStructure.reset_column_information

      BudgetStructure.find_each do |bs|
        bs.update_attribute :full_code, bs.send(:budget_structure)
      end
    rescue NameError
      puts "BudgetStructure class doesn't exist anymore\nSkiping migration..."
    end
  end
end
