LicitationCommissionResponsible.blueprint(:responsavel) do
  individual { Individual.make!(:sobrinho) }
  role { LicitationCommissionResponsibleRole::MAYOR }
  class_register { "123456" }
end

LicitationCommissionResponsible.blueprint(:advogado) do
  individual { Individual.make!(:wenderson) }
  role { LicitationCommissionResponsibleRole::LAWYER }
  class_register { "123457" }
end
