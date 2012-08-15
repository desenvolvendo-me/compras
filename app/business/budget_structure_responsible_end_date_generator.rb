class BudgetStructureResponsibleEndDateGenerator
  attr_accessor :budget_structure_object

  delegate :persisted_budget_structure_responsibles,
           :budget_structure_responsibles_changed?,
           :to => :budget_structure_object

  def initialize(budget_structure_object)
    self.budget_structure_object = budget_structure_object
  end

  def change!
    return unless budget_structure_responsibles_changed?

    persisted_budget_structure_responsibles.each do |responsible|
      if responsible.end_date.nil?
        responsible.end_date = Date.current
      end
    end
  end
end
