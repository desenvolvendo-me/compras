class PledgeLiquidationStatus < EnumerateIt::Base
  associate_values :active, :annulled
end
