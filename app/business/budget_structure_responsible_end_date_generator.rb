class BudgetStructureResponsibleEndDateGenerator
  attr_accessor :budget_structure_object

  delegate :persisted_budget_structure_responsibles_without_end_date,
           :budget_structure_responsibles_changed?,
           :to => :budget_structure_object

  def initialize(budget_structure_object)
    self.budget_structure_object = budget_structure_object
  end

  def change!
    return unless budget_structure_object.valid? && budget_structure_responsibles_changed?

    persisted_budget_structure_responsibles_without_end_date.each do |responsible|
      responsible.end_date = Date.current
    end
  end
end
