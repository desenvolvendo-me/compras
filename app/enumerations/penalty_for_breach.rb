class PenaltyForBreach < EnumerateIt::Base
  associate_values :difference_calculated, :difference_calculated_with_monetary_correction
end
