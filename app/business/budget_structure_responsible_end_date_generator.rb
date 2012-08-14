class BudgetStructureResponsibleEndDateGenerator
  attr_accessor :budget_structure_object

  def initialize(budget_structure_object)
    self.budget_structure_object = budget_structure_object
  end

  def change!
    responsibles.each do |responsible|
      if responsible.persisted? && responsible.end_date.nil?
        responsible.end_date = Date.current
      end
    end
  end

  def responsibles
    budget_structure_object.budget_structure_responsibles
  end
end
