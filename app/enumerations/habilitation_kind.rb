class HabilitationKind < EnumerateIt::Base
  associate_values :certificate_regularity_fgts, :certificate_regularity_inss,
                   :clearance_certificate_labor_debts
end
