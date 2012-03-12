class BidOpeningStatus < EnumerateIt::Base
  associate_values :waiting,
                   :released,
                   :canceled
end
