class CommissionType < EnumerateIt::Base
  associate_values :trading, :permanent, :special, :servers, :auctioneers
end
