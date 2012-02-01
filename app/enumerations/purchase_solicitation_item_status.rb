class PurchaseSolicitationItemStatus < EnumerateIt::Base
  associate_values :liberated, :grouped, :not_attended, :pending
end
