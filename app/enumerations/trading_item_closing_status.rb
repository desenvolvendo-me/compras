class TradingItemClosingStatus < EnumerateIt::Base
  associate_values :winner, :repealed, :failed, :abandoned
end
