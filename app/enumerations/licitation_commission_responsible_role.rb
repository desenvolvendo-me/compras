class LicitationCommissionResponsibleRole < EnumerateIt::Base
  associate_values :mayor, :financial_secretary, :administration_secretary, :purchase_and_licitation_director,
                   :purchase_and_licitation_leader, :lawyer
end
