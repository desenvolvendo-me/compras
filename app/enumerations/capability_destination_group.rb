class CapabilityDestinationGroup < EnumerateIt::Base
  associate_values :treasury_current_year,
                   :other_current_year,
                   :treasury_previous_years,
                   :other_previous_years,
                   :conditional
end
