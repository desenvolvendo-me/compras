class FulfillerType < EnumerateIt::Base
  associate_values :direct_purchase => 'DirectPurchase',
                   :administrative_process => 'AdministrativeProcess'
end
