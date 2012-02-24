class PledgeType < EnumerateIt::Base
  associate_values :ordinary, :global, :estimated
end
