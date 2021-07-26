LicitationCommissionResponsible.blueprint(:advogado) do
  individual { Individual.make!(:wenderson) }
  role { LicitationCommissionResponsibleRole::LAWYER }
  class_register { "123457" }
end
