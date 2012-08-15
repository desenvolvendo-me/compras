class CapabilityDestinationUse < EnumerateIt::Base
  associate_values :resources_not_for_counterpart,
                   :bird,
                   :bid,
                   :sector_loans,
                   :other_loans,
                   :donations
end
