class TypeOfRemoval < EnumerateIt::Base
  associate_values :removal_by_limit,
                   :removal_justified,
                   :removal_by_ineligibility,
                   :other_reasons_to_removal,
                   :unenforceability_accreditation,
                   :dispensation_justified_accreditation,
                   :call
end
