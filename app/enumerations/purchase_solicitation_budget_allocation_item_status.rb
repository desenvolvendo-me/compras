class PurchaseSolicitationBudgetAllocationItemStatus < EnumerateIt::Base
  associate_values :pending, :grouped, :attended, :partially_fulfilled
end
