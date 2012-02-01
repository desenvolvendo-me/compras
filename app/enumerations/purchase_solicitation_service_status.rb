class PurchaseSolicitationServiceStatus < EnumerateIt::Base
  associate_values :pending, :liberated, :not_liberated, :attended
end
