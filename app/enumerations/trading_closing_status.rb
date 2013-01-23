class TradingClosingStatus < EnumerateIt::Base
  associate_values :suspended, :closed_with_resource, :closed_without_resource,
                   :repealed, :failed, :abandoned, :reopened
end
