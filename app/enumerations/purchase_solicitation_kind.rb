class PurchaseSolicitationKind < EnumerateIt::Base
  associate_values :products, :goods, :services
end
