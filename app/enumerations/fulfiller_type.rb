class FulfillerType < EnumerateIt::Base
  associate_values :direct_purchase => 'DirectPurchase',
                   :licitation_process => 'LicitationProcess'
end
