class BudgetStructureResponsibleEndDateGenerator
  attr_accessor :budget_structure_responsible_repository

  def initialize(budget_structure_responsible_repository)
    self.budget_structure_responsible_repository = budget_structure_responsible_repository
  end

  def change!
    responsibles.each do |responsible|
      if responsible.persisted? && responsible.end_date.nil?
        responsible.end_date = Date.current
      end
    end
  end

  def responsibles
    budget_structure_responsible_repository.budget_structure_responsibles
  end
end
