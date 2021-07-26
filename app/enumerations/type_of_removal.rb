class TypeOfRemoval < EnumerateIt::Base
  associate_values :removal_by_limit,
                   :removal_justified,
                   :removal_by_ineligibility,
                   :unenforceability_accreditation,
                   :dispensation_justified_accreditation,
                   :call,
                   :trading


  def self.allow_duplicated_items
    [
      DISPENSATION_JUSTIFIED_ACCREDITATION,
      UNENFORCEABILITY_ACCREDITATION
    ]
  end
end
